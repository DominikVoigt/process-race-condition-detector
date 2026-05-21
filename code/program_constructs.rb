require "./data_structure_tree.rb"

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
        # Associated Variable, operators: DataStructureTree::Nodes in Data Structure tree
        def initialize(name, target, operands, eval)
            @name = name
            # Data Structure Tree DataStructureTree::Nodes
            @target = target
            @operands = operands
            @eval = eval
        end

        attr_accessor :name
        attr_accessor :target
        attr_accessor :operands
        attr_accessor :eval

        def to_s = "Operation: #{@name}"

        def inspect = to_s

        def write? = Ops::WRITE_OPS.include? @name

        def equality? =  @name.to_s.include? "_eq"
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

        def self.compute_conflicts(op1, op2)
            pp Ops::Int::CONFLICT_SETS[op1.name]
            p op2.name
            pp op2.name.class
            pp Ops::Int::CONFLICT_SETS[op1.name].include? op2.name
            Ops::Int::CONFLICT_SETS[op1.name].include? op2.name
        end
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

        def self.compute_conflicts(op1, op2)
            Ops::Float::CONFLICT_SETS[op1.name].include? op2.name
        end
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

        def self.compute_conflicts(op1, op2)
            Ops::Bool::CONFLICT_SETS[op1.name].include? op2.name
        end
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

        # For a pair of operations returns true if there is a conflict
        # This method is conservative, if it cannot determine whether a pair of methods
        # is in conflict, due to dynamic operations, it will assume it does.
        # These can be refined
        def self.compute_conflicts(op1, op2)
            case op1.name
                when Ops::List::ASSIGN
                    true
                when Ops::List::EQUAL
                    Ops::List::WRITE.include? op2.name
                when Ops::List::SIZE
                    Ops::List::WRITE.include? op2.name
                when Ops::List::INS
                    case op2.name
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
                            assert { !(op1.operands[0].is_a?(DataStructureTree::Node)) }
                            assert { !(op2.operands[0].is_a?(DataStructureTree::Node)) }
                            # Insert will invalidate all indices at the >= the insertion position
                            op1.operands[0] <= op2.operands[0]
                        when Ops::List::CONT
                            true
                        end
                when Ops::List::RETR
                    case op2.name
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
                            assert { !(op1.operands[0].is_a?(DataStructureTree::Node)) }
                            assert { !(op2.operands[0].is_a?(DataStructureTree::Node)) }
                            # Remove will invalidate all indices at the >= the insertion position
                            op2.operands[0] <= op1.operands[0]
                        when Ops::List::RETR
                            false
                        when Ops::List::CONT
                            # TODO
                            true
                        end
                when Ops::List::RM
                    case op2.name
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
                            assert { !(op1.operands[0].is_a?(DataStructureTree::Node)) }
                            assert { !(op2.operands[0].is_a?(DataStructureTree::Node)) }
                            # Insert will invalidate all indices at the >= the insertion position
                            op1.operands[0] <= op2.operands[0]
                        when Ops::List::CONT
                            # TODO
                            true
                        end
                end
        end
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

        # For a pair of operations returns true if there is a conflict
        # This method is conservative, if it cannot determine whether a pair of methods
        # is in conflict, due to dynamic operations, it will assume it does.
        # These can be refined
        def self.compute_conflicts(op1, op2)
            case op1.name
                when Ops::Hash::ASSIGN
                    true
                when Ops::Hash::EQUAL
                    Ops::Hash::WRITE.include? op2.name
                when Ops::Hash::SIZE
                    Ops::Hash::WRITE.include? op2.name
                when Ops::Hash::INS
                    case op2.name
                        when Ops::Hash::ASSIGN
                            true
                        when Ops::Hash::EQUAL
                            true
                        when Ops::Hash::SIZE
                            true
                        when Ops::Hash::INS
                            # Operand 0 is the key for both ops, needs to be static for check
                            assert { !(op1.operands[0].is_a?(DataStructureTree::Node)) }
                            assert { !(op2.operands[0].is_a?(DataStructureTree::Node)) }
                            op1.operands[0] == op2.operands[0]
                        when Ops::Hash::RM
                            # Operand 0 is the key for both ops, needs to be static for check
                            assert { !(op1.operands[0].is_a?(DataStructureTree::Node)) }
                            assert { !(op2.operands[0].is_a?(DataStructureTree::Node)) }
                            op1.operands[0] == op2.operands[0]
                        when Ops::Hash::RETR
                            # Operand 0 is the key for both ops, needs to be static for check
                            assert { !(op1.operands[0].is_a?(DataStructureTree::Node)) }
                            assert { !(op2.operands[0].is_a?(DataStructureTree::Node)) }
                            op1.operands[0] == op2.operands[0]
                        when Ops::Hash::CONT
                            # Operand 0 is the key for both ops, needs to be static for check
                            assert { !(op1.operands[0].is_a?(DataStructureTree::Node)) }
                            assert { !(op2.operands[0].is_a?(DataStructureTree::Node)) }
                            op1.operands[0] == op2.operands[0]
                    end
                when Ops::Hash::RETR
                    case op2.name
                        when Ops::Hash::ASSIGN
                            true
                        when Ops::Hash::EQUAL
                            false
                        when Ops::Hash::SIZE
                            false
                        when Ops::Hash::INS
                            # Operand 0 is the key for both ops, needs to be static for check
                            assert { !(op1.operands[0].is_a?(DataStructureTree::Node)) }
                            assert { !(op2.operands[0].is_a?(DataStructureTree::Node)) }
                            op1.operands[0] == op2.operands[0]
                        when Ops::Hash::RM
                            # Operand 0 is the key for both ops, needs to be static for check
                            assert { !(op1.operands[0].is_a?(DataStructureTree::Node)) }
                            assert { !(op2.operands[0].is_a?(DataStructureTree::Node)) }
                            op1.operands[0] == op2.operands[0]
                        when Ops::Hash::RETR
                            false
                        when Ops::Hash::CONT
                            false
                    end
                when Ops::Hash::RM
                    case op2.name
                        when Ops::Hash::ASSIGN
                            true
                        when Ops::Hash::EQUAL
                            # TODO: Refine
                            true
                        when Ops::Hash::SIZE
                            # TODO: Refine
                            true
                        when Ops::Hash::INS                        
                            # Operand 0 is the key for both ops, needs to be static for check
                            assert { !(op1.operands[0].is_a?(DataStructureTree::Node)) }
                            assert { !(op2.operands[0].is_a?(DataStructureTree::Node)) }
                            op1.operands[0] == op2.operands[0]
                        when Ops::Hash::RM
                            false
                        when Ops::Hash::RETR
                            # Operand 0 is the key for both ops, needs to be static for check
                            assert { !(op1.operands[0].is_a?(DataStructureTree::Node)) }
                            assert { !(op2.operands[0].is_a?(DataStructureTree::Node)) }
                            op1.operands[0] == op2.operands[0]
                        when Ops::Hash::CONT
                            # Operand 0 is the key for both ops, needs to be static for check
                            assert { !(op1.operands[0].is_a?(DataStructureTree::Node)) }
                            assert { !(op2.operands[0].is_a?(DataStructureTree::Node)) }
                            op1.operands[0] == op2.operands[0]
                    end
                when Ops::Hash::CONT
                    case op2.name
                        when Ops::Hash::ASSIGN
                            true
                        when Ops::Hash::EQUAL
                            # TODO: Refine
                            false
                        when Ops::Hash::SIZE
                            # TODO: Refine
                            false
                        when Ops::Hash::INS                        
                            # Operand 0 is the key for both ops, needs to be static for check
                            assert { !(op1.operands[0].is_a?(DataStructureTree::Node)) }
                            assert { !(op2.operands[0].is_a?(DataStructureTree::Node)) }
                            op1.operands[0] == op2.operands[0]
                        when Ops::Hash::RM
                            # Operand 0 is the key for both ops, needs to be static for check
                            assert { !(op1.operands[0].is_a?(DataStructureTree::Node)) }
                            assert { !(op2.operands[0].is_a?(DataStructureTree::Node)) }
                            op1.operands[0] == op2.operands[0]
                        when Ops::Hash::RETR
                            false
                        when Ops::Hash::CONT
                            false
                    end
                end
        end
    end

    WRITE_OPS = Int::WRITE + Float::WRITE + Bool::WRITE + List::WRITE + Hash::WRITE
end