require "./program_constructs.rb"
require "./process_tree"
require "./data_structure_tree.rb"

data = {"x" => 3, "p" => { "y" => 3}}
activity_a = ProcessTree::Activity.new(false, "A", [])
root = activity_a
data_structure_trees, direct_access = DataStructureTree::construct_trees(data)

pp data_structure_trees

def identify_race_conditions(root, concurrency_candidates, direct_access)
    race_condition_pairs = []
    queue = [root]
    # iterate through the nodes of the process tree in level order
    while !queue.empty?
        node = stack.shift
        node.statements.each do |statement|
            write = statement.write?
            statement.operations.each do |op|
                
            end
        end

        # Insert all children into the queue
        if node.instance_of? Gateway
            queue += node.children
        end
    end
end