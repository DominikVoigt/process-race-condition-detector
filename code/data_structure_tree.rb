require "./assert.rb"

module DataStructureTree

    # Given the data elements as a hash: (key: element identifier, value:value)
    # Outputs a tree for every "root" data element in the hash
    # All other data elements (e.g., members of root hash data elements) are nodes under their associated data structure tree node (e.g., the node of the hash data element)
    # All nodes of data elements can be accessed directly using the direct_access hash.
    # Here each node is stored under its access path in the normal way.
    #
    # Input, a single hash data element named p:
    #
    #   p = {
    #     "a" => 3
    #   }
    #
    # Output, a single tree in the root level with a single child:
    #
    #   trees = [(p)->[(a)]]
    #
    #   direct_access = {
    #                     "p" => (p),
    #                     "p['a']" => (a)
    #                   } 
    #
    def self.construct_trees(data_elements)
        assert {data_elements.instance_of? Hash}
        trees = {}
        direct_access = {}
        data_elements.each {|key, value| trees[key] = construct_tree(key, value, direct_access)}

        [trees, direct_access]
    end

    # Constructs the data structure tree for a single data element (and direct access hash)
    # For complex data types (data structures), it constructs the tree recursively
    def self.construct_tree(name, element, direct_access)
        if element.instance_of? Hash
            children = {}
            element.each { |key, value|
                # Construct child tree for every hash entry and store the root node under the original hash key 
                children[key] = construct_tree(name+"['"+key+"']", value, direct_access)
            }
            node = HashNode.new(name, children)
        elsif element.instance_of? Array
            children = []
            element.each_with_index { |value, idx| 
                # Construct child tree for every array entry and store the root node at the original index
                children << construct_tree(name+'['+idx.to_s+']', value, direct_access)
            }
            node = ArrayNode.new(name, children)
        else
            node = SimpleNode.new(name)
        end
        direct_access[name] = node
        node
    end

    class Node 
        attr_accessor :name
        attr_accessor :operations
        attr_accessor :marking
        
        # Annotate the DataStructureTree node with the operation
        def annotate(operation, pt_node) 
            # Add the operation to the set of the ProcessTreeNode that executed it
            if !operations.include? pt_node
                operations[pt_node] = Set.new
            end 
            operations[pt_node].add(operation)
        end

        def mark(operation, pt_node) 
            # Add the operation to the set of the ProcessTreeNode that executed it
            if !operations.include? pt_node
                operations[pt_node] = Set.new
            end 
            operations[pt_node].add(operation)
        end
        
        def inspect = to_s
    end

    class SimpleNode < Node
        def initialize(name)
            @name = name
            @operations = {}
            @marking = {}
        end
        
        def to_s = "Simple(#{@name}, Operations: #{@operations})"

        def contains?(other_node_name) = @name == other_node_name
    end

    class ComplexNode < Node 
        attr_accessor :children
        attr_accessor :members

        def contains?(other_node_name) = @members.include? other_node_name
        
        def mark(operation, node) 
        end
    
    end

    class HashNode < ComplexNode
        def initialize(name, children)
            assert { children.instance_of? Hash }
            @name = name
            @operations = {}
            @children = children
            # Contains all nodes that write to the node or a specific subtree
            @marking = {}
            # Stores the name of all child nodes
            @members = Set.new()
            @members.add name
            children.each do |key, child|
                @members.add child.name
                if child.is_a? ComplexNode
                    @members.merge child.members
                end
            end
        end
        
        def to_s = "Hash(#{@name}, Operations: #{@operations}, Children: #{children})"

    end

    class ArrayNode < ComplexNode
        def initialize(name, children)
            assert { children.instance_of? Array }
            @name = name
            @operations = {}
            @children = children
            # Contains all nodes that write to the node or a specific subtree
            @marking = {}
            @members = Set.new([name])
            children.each do |child|
                @members.add(child.name)
                if child.is_a?(HashNode) || child.instance_of?(ArrayNode)
                    @members.union child.members
                end
            end
        end
        
        def to_s = "Array(#{@name}, Operations: #{@operations}, Children: #{children})"
    end
end

# data = {"a" => 3, "x" => { "y" => { "z" => [3, 4] } } } # 
# data_structure_trees, direct_access = DataStructureTree::construct_trees(data)
# tree_x = data_structure_trees["x"]
# pp tree_x.members
# pp tree_x.children
# pp tree_x.contains? "x['y']"
# pp tree_x.contains? "x['y']['z']"
# pp data_structure_trees
