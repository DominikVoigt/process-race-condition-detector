require "./program_constructs.rb"
require "./process_tree"
require "./data_structure_tree.rb"
require "./concurrency_candidates.rb"

def compute_conflicts(operand, operation, concurrency_candidate_set)
    pp "Computing candidates for #{operand}"
    return Set.new
end

def identify_race_conditions(root, concurrency_candidates, direct_access)
    pp concurrency_candidates
    race_condition_pairs = Set.new
    queue = [root]
    # iterate through the nodes of the process tree in level order
    while !queue.empty?
        node = queue.shift
        node.statements.each do |statement|
            write = statement.write?
            pp statement.to_s
            target = statement.last.target
            statement.operations.each do |op|
                associated_variable = op.target
                target.annotate([op, node])
                if write and associated_variable.contains? target
                    associated_variable.mark([op, node])
                end
                race_condition_pairs.merge compute_conflicts(associated_variable, op, concurrency_candidates[node])
                
                op.operands.each do |operand|
                    operand.annotate(op.eval)
                    race_condition_pairs.merge compute_conflicts(operand, op, concurrency_candidates[node])
                end
            end
        end
        
        # Insert all children into the queue
        if node.instance_of? ProcessTree::Gateway
            queue += node.children
        end
    end

    pp race_condition_pairs
end
