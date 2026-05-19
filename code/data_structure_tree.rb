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
        data_elements.each {|key, value| trees[key] = construct_tree(key, value, {})}

        [trees, direct_access]
    end

    # Constructs the data structure tree for a single data element (and direct access hash)
    # For complex data types (data structures), it constructs the tree recursively
    def self.construct_tree(name, element, direct_access)
        if element.instance_of? Hash
            pp "hash"
            children = {}
            element.each {|key, value| children[key] = construct_tree(name+"['"+key+"']", value, direct_access)}
            node = ComplexNode.new(name, children)
        elsif element.instance_of? Array
            pp "array"
            children = []
            element.each_with_index {|value, idx| children << construct_tree(name+'['+idx.to_s+']', value, direct_access)}
            node = ComplexNode.new(name, children)
        else
            pp "simple"
            node = SimpleNode.new(name)
        end
        direct_access[name] = node
        node
    end

    class Node 
        def annotate(operation) end
    end

    class SimpleNode < Node
        def initialize(name)
            @name = name
            @operations = {}
        end

        def inspect = to_s
        
        def to_s 
            "SimpleNode(#{@name}, #{@operations})"
        end

        def annotate(operation)
        
        end
    end

    class ComplexNode < Node
        def initialize(name, children)
            @name = name
            @operations = {}
            @children = children
        end

        attr_accessor :children
        
        def inspect = to_s
        
        def to_s 
            "Complex(#{@name}, #{@operations}, #{children.to_s})"
        end

        def annotate(operation)
            
        end
    end
end