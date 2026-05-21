require "./program_constructs.rb"
require "./process_tree"
require "./data_structure_tree.rb"
require "./concurrency_candidates.rb"

# Computes whether two operations on a node are conflicting
def conflicting?(op_1, op_2)
    type_1 = op_1.name.to_s.split('_')[0]
    type_2 = op_2.name.to_s.split('_')[0]
    assert {type_1 == type_2}
    pp "Computing conflict for operation pair #{op_1}, #{op_2}"
    res = case type_1
        when "int"
            Ops::Int::compute_conflicts(op_1, op_2)
        when "float"
            Ops::Float::compute_conflicts(op_1, op_2)
        when "bool"
            Ops::Bool::compute_conflicts(op_1, op_2)
        when "list"
            Ops::List::compute_conflicts(op_1, op_2)
        when "hash"
            Ops::Hash::compute_conflicts(op_1, op_2)
        end
end

# Computes the set of conflicting nodes 
# operand: The DataStructureTree node the operation is done on
# operation: The operation executed on the DataStructureTree node
# concurrency_candidate_set: Set of ProcessTree nodes that are concurrency candidates
# is_target: whether the operand is the associated variable (true) or not (false)
def compute_conflicts(operand, operation, concurrency_candidate_set, source)
    conflicting_set = Set.new
    # Recursive method (equality check on Complex types)
    if operation.equality?
        concurrency_candidate_set.each do |candidate|
            # If the datastructuretree node is marked by concurrent candidate there is a conflict
            if operand.marking[candidate]
                pp "Detected Marking by concurrency candidate #{candidate} when processing equality op"
                conflicting_set.add([source, candidate])
            end
        end
    end
    # Check for each annotation of a concurrency candidate whether it is conflicting
    operand.operations.each do |candidate, op_set|
        if concurrency_candidate_set.include? candidate
            pp "Operand #{operand.name}, was annotated by concurrency candidate #{candidate}: #{op_set}"
            # Check whether the operations done by the concurrency candidate are conflicting
            op_set.each do |annotation|
                if conflicting?(annotation, operation)
                    pp "Operation #{annotation} of PT node #{candidate} is conflicting with operation #{operation} of PT node #{source}"
                    conflicting_set.add [source, candidate]
                    break
                end
            end
        end
    end
    
    return conflicting_set
end

def identify_race_conditions(root, concurrency_candidates, direct_access)
    race_condition_pairs = Set.new
    queue = [root]
    # iterate through the nodes of the process tree in level order
    while !queue.empty?
        node = queue.shift
        p "Processing node #{node}:"
        node.statements.each do |statement|
            # All operations that cannot be mapped exactly to a node
            write = statement.write?
            target = statement.last.target
            statement.operations.each do |op|
                associated_variable = op.target
                associated_variable.annotate(op, node)
                if write and associated_variable.contains? target
                    race_condition_pairs.merge associated_variable.mark(op, node, concurrency_candidates[node])
                end
                race_condition_pairs.merge compute_conflicts(associated_variable, op, concurrency_candidates[node], node)
                op.operands.each do |operand|
                    # If it is not a literal, annotate it
                    if operand.is_a? DataStructureTree::Node
                        # For all non-equality, operation on operand is evaluation
                        if !op.equality?
                            op = ProgramConstructs::Operation.new(op.eval, self, [], op.eval)
                        end
                        operand.annotate(op, node)
                        race_condition_pairs.merge compute_conflicts(operand, op, concurrency_candidates[node], node)
                    end
                end
            end
        end
        
        # Insert all children into the queue
        if node.is_a? ProcessTree::Gateway
            queue += node.children
        end
    end

    race_condition_pairs
end
