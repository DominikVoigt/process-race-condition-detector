require "./assert.rb"

module ProcessTree
    class Activity
        def initialize(is_tau, label, statements)
            @is_tau = is_tau
            @label = label
            @statements = statements
        end

        attr_reader :statements

        def is_tau? = @is_tau 

        def ops = @statements.flatten

        def to_s = @is_tau ? "tau" : @label
            
        def inspect = to_s
    end

    class Gateway 
        def initialize(children)
            @children = children 
        end

        attr_reader :children
    end

    class ParallelGateway < Gateway
    end

    class ChoiceGateway < Gateway
        def initialize(children, conditions)
            # Children include all branches + 1 Default Branch
            # Conditions include conditions for all branches 
            assert {children.size() == conditions.size() + 1}
            @children = children
            # Each condition is a statement
            @conditions = conditions
        end
    end

    class SequenceGateway < Gateway
    end
end