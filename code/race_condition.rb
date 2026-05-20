require "./program_constructs.rb"
require "./process_tree"
require "./data_structure_tree.rb"
require "./concurrency_candidates.rb"

def conflicting?(op_1, op_2)
    type_1 = op_1.name.to_s.split('_')[0]
    type_2 = op_2.name.to_s.split('_')[0]
    assert {type_1 == type_2}
    case type_1
        when "int"
            Ops::Int::CONFLICT_SETS[op_1.name].include? op_2.name
        when "float"
            Ops::Float::CONFLICT_SETS[op_1.name].include? op_2.name
        when "bool"
            Ops::Bool::CONFLICT_SETS[op_1.name].include? op_2.name
        when "list"
            case op_1.name
                when Ops::List::ASSIGN
                    true
                when Ops::List::EQUAL
                    Ops::List::WRITE.include? op_2.name
                when Ops::List::SIZE
                    Ops::List::WRITE.include? op_2.name
                when Ops::List::INS
                    case op_2.name
                        when Ops::List::ASSIGN
                            true
                        when Ops::List::EQUAL
                            true
                        when Ops::List::SIZE
                            true
                        when Ops::List::INS
                            # Moves the position of the other insert
                            true
                        when Ops::List::RM
                            # Insert moves which element is removed
                            true
                        when Ops::List::RETR
                            # Operand 0 is the index for both ops, needs to be static for check
                            assert { !(op_1.operands[0].is_a?(Node)) }
                            assert { !(op_2.operands[0].is_a?(Node)) }
                            # Insert will invalidate all indices at the >= the insertion position
                            op_1.operands[0] <= op_2.operands[0]
                        when Ops::List::CONT
                            true
                        end
                when Ops::List::RETR
                    case op_2.name
                        when Ops::List::ASSIGN
                            true
                        when Ops::List::EQUAL
                            false
                        when Ops::List::SIZE
                            false
                        when Ops::List::INS
                            # Moves the position of the second insert
                            true
                        when Ops::List::RM
                            # Operand 0 is the index for both ops, needs to be static for check
                            assert { !(op_1.operands[0].is_a?(Node)) }
                            assert { !(op_2.operands[0].is_a?(Node)) }
                            # Remove will invalidate all indices at the >= the insertion position
                            op_2.operands[0] <= op_1.operands[0]
                        when Ops::List::RETR
                            false
                        when Ops::List::CONT
                            # TODO
                            true
                        end
                when Ops::List::RM
                    case op_2.name
                        when Ops::List::ASSIGN
                            true
                        when Ops::List::EQUAL
                            # TODO: Refine
                            true
                        when Ops::List::SIZE
                            # TODO: Refine
                            true
                        when Ops::List::INS
                            # Moves the position of the second insert
                            true
                        when Ops::List::RM
                            # RM moves which element is removed
                            true
                        when Ops::List::RETR
                            # Operand 0 is the index for both ops, needs to be static for check
                            assert { !(op_1.operands[0].is_a?(Node)) }
                            assert { !(op_2.operands[0].is_a?(Node)) }
                            # Insert will invalidate all indices at the >= the insertion position
                            op_1.operands[0] <= op_2.operands[0]
                        when Ops::List::CONT
                            # TODO
                            true
                        end
                end
    
        when "hash"
            case op_1.name
                when Ops::List::ASSIGN
                    true
                when Ops::List::EQUAL
                    Ops::List::WRITE.include? op_2.name
                when Ops::List::SIZE
                    Ops::List::WRITE.include? op_2.name
                when Ops::List::INS
                    case op_2.name
                        when Ops::List::ASSIGN
                            true
                        when Ops::List::EQUAL
                            true
                        when Ops::List::SIZE
                            true
                        when Ops::List::Insert
                            # Operand 0 is the key for both ops, needs to be static for check
                            assert { !(op_1.operands[0].is_a?(Node)) }
                            assert { !(op_2.operands[0].is_a?(Node)) }
                            op_1.operands[0] == op_2.operands[0]
                        when Ops::List::RM
                            # Operand 0 is the key for both ops, needs to be static for check
                            assert { !(op_1.operands[0].is_a?(Node)) }
                            assert { !(op_2.operands[0].is_a?(Node)) }
                            op_1.operands[0] == op_2.operands[0]
                        when Ops::List::RETR
                            # Operand 0 is the key for both ops, needs to be static for check
                            assert { !(op_1.operands[0].is_a?(Node)) }
                            assert { !(op_2.operands[0].is_a?(Node)) }
                            op_1.operands[0] == op_2.operands[0]
                        when Ops::List::CONT
                            # Operand 0 is the key for both ops, needs to be static for check
                            assert { !(op_1.operands[0].is_a?(Node)) }
                            assert { !(op_2.operands[0].is_a?(Node)) }
                            op_1.operands[0] == op_2.operands[0]
                    end
                when Ops::List::RETR
                    case op_2.name
                        when Ops::List::ASSIGN
                            true
                        when Ops::List::EQUAL
                            false
                        when Ops::List::SIZE
                            false
                        when Ops::List::INS
                            # Operand 0 is the key for both ops, needs to be static for check
                            assert { !(op_1.operands[0].is_a?(Node)) }
                            assert { !(op_2.operands[0].is_a?(Node)) }
                            op_1.operands[0] == op_2.operands[0]
                        when Ops::List::RM
                            # Operand 0 is the key for both ops, needs to be static for check
                            assert { !(op_1.operands[0].is_a?(Node)) }
                            assert { !(op_2.operands[0].is_a?(Node)) }
                            op_1.operands[0] == op_2.operands[0]
                        when Ops::List::RETR
                            false
                        when Ops::List::CONT
                            false
                    end
                when Ops::List::RM
                    case op_2.name
                        when Ops::List::ASSIGN
                            true
                        when Ops::List::EQUAL
                            # TODO: Refine
                            true
                        when Ops::List::SIZE
                            # TODO: Refine
                            true
                        when Ops::List::INS                        
                            # Operand 0 is the key for both ops, needs to be static for check
                            assert { !(op_1.operands[0].is_a?(Node)) }
                            assert { !(op_2.operands[0].is_a?(Node)) }
                            op_1.operands[0] == op_2.operands[0]
                        when Ops::List::RM
                            false
                        when Ops::List::RETR
                            # Operand 0 is the key for both ops, needs to be static for check
                            assert { !(op_1.operands[0].is_a?(Node)) }
                            assert { !(op_2.operands[0].is_a?(Node)) }
                            op_1.operands[0] == op_2.operands[0]
                        when Ops::List::CONT
                            # Operand 0 is the key for both ops, needs to be static for check
                            assert { !(op_1.operands[0].is_a?(Node)) }
                            assert { !(op_2.operands[0].is_a?(Node)) }
                            op_1.operands[0] == op_2.operands[0]
                    end
                when Ops::List::CONT
                    case op_2.name
                        when Ops::List::ASSIGN
                            true
                        when Ops::List::EQUAL
                            # TODO: Refine
                            false
                        when Ops::List::SIZE
                            # TODO: Refine
                            false
                        when Ops::List::INS                        
                            # Operand 0 is the key for both ops, needs to be static for check
                            assert { !(op_1.operands[0].is_a?(Node)) }
                            assert { !(op_2.operands[0].is_a?(Node)) }
                            op_1.operands[0] == op_2.operands[0]
                        when Ops::List::RM
                            # Operand 0 is the key for both ops, needs to be static for check
                            assert { !(op_1.operands[0].is_a?(Node)) }
                            assert { !(op_2.operands[0].is_a?(Node)) }
                            op_1.operands[0] == op_2.operands[0]
                        when Ops::List::RETR
                            false
                        when Ops::List::CONT
                            false
                    end
            end
        end
end

# Computes the set of conflicting nodes 
# operand: The DataStructureTree node the operation is done on
# operation: The operation executed on the DataStructureTree node
# concurrency_candidate_set: Set of ProcessTree nodes that are concurrency candidates
def compute_conflicts(operand, operation, concurrency_candidate_set, source)
    conflicting_set = Set.new
    # Recursive method (equality check on Complex types)
    if operation.name == Ops::Hash::EQUAL or operation.name == Ops::List::EQUAL
        operand.marking.intersection(concurrency_candidate_set).each do |conflicting_node|
            pp "Concurrent candidate marked node prior, conflict"
        end
    end
    # Check for each annotation of a concurrency candidate whether it is conflicting
    operand.operations.each do |pt_node, op_set|
        if concurrency_candidate_set.include? pt_node
            pp "Operand #{operand.name}, was annotated by concurrency candidate #{pt_node}: #{op_set}"
            # Check whether the operations done by the concurrency candidate are conflicting
            op_set.each do |annotated_op|
                if conflicting? annotated_op, operation
                    pp "Operation #{annotated_op} of PT node #{pt_node} is conflicting with operation #{operation} of PT node #{source}"
                    conflicting_set.add pt_node
                    break
                end
            end
        end
    end
    
    return conflicting_set
end

def identify_race_conditions(root, concurrency_candidates, direct_access)
    pp concurrency_candidates
    race_condition_pairs = Set.new
    queue = [root]
    # iterate through the nodes of the process tree in level order
    while !queue.empty?
        node = queue.shift
        pp "Processing node #{node}"
        node.statements.each do |statement|
            # All operations that cannot be mapped exactly to a node
            write = statement.write?
            target = statement.last.target
            statement.operations.each do |op|
                associated_variable = op.target
                target.annotate(op, node)
                if write and associated_variable.contains? target
                    associated_variable.mark(op, node)
                end
                race_condition_pairs.merge compute_conflicts(associated_variable, op, concurrency_candidates[node], node)
                op.operands.each do |operand|
                    # If it is not a literal, annotate it
                    if operand.is_a? DataStructureTree::Node
                        operand.annotate(op.eval, node)
                        race_condition_pairs.merge compute_conflicts(operand, op.eval, concurrency_candidates[node], node)
                    end
                end
            end
        end
        
        # Insert all children into the queue
        if node.is_a? ProcessTree::Gateway
            queue += node.children
        end
    end
end
