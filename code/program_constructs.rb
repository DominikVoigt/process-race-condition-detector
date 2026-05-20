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
        # All write operations
        WRITE = [ASSIGN, ADD, MULT, DIV]
        # All read operations
        READ = [EVAL, EQUAL, GT, LT]
        CONFLICT_SETS = {
            :int_eval => Set.new(WRITE),
            :int_eq => Set.new(WRITE),
            :int_gt => Set.new(WRITE),
            :int_lt => Set.new(WRITE),
            :int_assign => Set.new(READ + WRITE),
            :int_add => Set.new(READ + [ASSIGN, MULT, DIV]),
            :int_mult => Set.new(READ + [ASSIGN, ADD]),
            :int_div => Set.new(READ + [ASSIGN, ADD])
        }
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

        # All write operations
        WRITE = [ASSIGN, ADD, MULT, DIV]
        # All read operations
        READ = [EVAL, EQUAL, GT, LT]

        CONFLICT_SETS = {
            :float_eval => Set.new(WRITE),
            :float_eq => Set.new(WRITE),
            :float_gt => Set.new(WRITE),
            :float_lt => Set.new(WRITE),
            :float_assign => Set.new(READ + WRITE),
            :float_add => Set.new(READ + [ASSIGN, MULT, DIV]),
            :float_mult => Set.new(READ + [ASSIGN, ADD]),
            :float_div => Set.new(READ + [ASSIGN, ADD])
        }
    end

    module Bool
        ASSIGN =    :bool_assign
        NEG =       :bool_neg
        EVAL =      :bool_eval
        EQUAL =     :bool_eq

        # All write operations
        WRITE = [ASSIGN, NEG]
        # All read operations
        READ = [EVAL, EQUAL]
        CONFLICT_SETS = {
            :bool_eval => Set.new(WRITE),
            :bool_eq => Set.new(WRITE),
            :bool_assign => Set.new(READ + WRITE),
            :bool_neg => Set.new(READ + [ASSIGN])
        }
    end
        
    module List
        ASSIGN =    :list_assign
        EQUAL =     :list_eq
        SIZE =      :list_size
        INS =       :list_insert
        RM =        :list_remove
        RETR =      :list_retrieve

        # All write operations, conflict set of all read ops
        WRITE = [ASSIGN, INS, RM]
        # All read operations
        READ = [EQUAL, SIZE, RETR]
    end

    module Hash
        ASSIGN =    :hash_assign
        EQUAL =     :hash_eq
        SIZE =      :hash_neg
        INS =       :hash_insert
        RM =        :hash_remove
        RETR =      :hash_retrieve
        CONT =      :hash_contains

        # All write operations, conflict set of all read ops
        WRITE = [ASSIGN, INS, RM]
        # All read operations
        READ = [EQUAL, SIZE, RETR, CONT]
    end

    WRITE_OPS = Int::WRITE + Float::WRITE + Bool::WRITE + List::WRITE + Hash::WRITE
end