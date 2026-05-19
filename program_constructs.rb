module ProgramConstructs

    class Statement
        def initialize(operations)
            @operations = operations
        end

        def write?
            @operations.last.write?
        end
    end

    class Operation
        # Associated Variable, operators: Nodes in Data Structure tree
        def initialize(op, associated_variable, operators)
            @op = op
            @associated_variable = associated_variable
            @operators = operators
        end

        def write?
            op in Ops::WRITE_OPS
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