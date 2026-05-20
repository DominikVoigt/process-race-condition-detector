module ProgramConstructs

    class Statement
        def initialize(operations)
            @operations = operations
        end

        attr_accessor :operations

        inspect = to_s

        def to_s = "Statement: #{@operations}"

        def write? = @operations.last.write?

        def last = @operations.last
    end

    class Operation
        # Associated Variable, operators: Nodes in Data Structure tree
        def initialize(name, target, operands, eval)
            @name = name
            @target = target
            @operands = operands
            @eval = eval
        end

        attr_accessor :name
        attr_accessor :target
        attr_accessor :operands
        attr_accessor :eval

        def to_s = "Operation: #{@name}"

        inspect = to_s


        def write?
            Ops::WRITE_OPS.include? @name
        end
    end
end

module Ops
    module Int
        ASSIGN =    :int_assign
        ADD =       :int_add
        MULT =      :int_mult
        DIV =       :int_div
        EVAL =      :int_eval
        EQUAL =     :int_eq
        GT =        :int_gt
        LT =        :int_lt
    end

    module Float
        ASSIGN =    :float_assign
        ADD =       :float_add
        MULT =      :float_mult
        DIV =       :float_div
        EVAL =      :float_eval
        EQUAL =     :float_eq
        GT =        :float_gt
        LT =        :float_lt
    end

    module Bool
        ASSIGN =    :bool_assign
        NEG =       :bool_neg
        EVAL =      :bool_eval
        EQUAL =     :bool_eq
    end
        
    module List
        ASSIGN =    :list_assign
        INS =       :list_insert
        RM =        :list_remove
        EQUAL =     :list_eq
        SIZE =      :list_neg
        RETR =      :list_retrieve
        CONT =      :list_contains
    end

    module Hash
        ASSIGN =    :hash_assign
        INS =       :hash_insert
        RM =        :hash_remove
        EQUAL =     :hash_eq
        SIZE =      :hash_neg
        RETR =      :hash_retrieve
        CONT =      :hash_contains
    end

    WRITE_OPS = [
        Int::ASSIGN, Int::ADD, Int::MULT, Int::DIV,
        Float::ASSIGN, Float::ADD, Float::MULT, Float::DIV,
        Bool::ASSIGN, Bool::NEG, Int::MULT, Int::DIV,
        List::ASSIGN, List::INS, List::RM,
        Hash::ASSIGN, Hash::INS, Hash::RM
    ]   
end