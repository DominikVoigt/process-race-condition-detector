require "./data_structure_tree.rb"
require "./program_constructs.rb"
require "./concurrency_candidates.rb"
require "./race_condition.rb"

def construct_simple_data_tree
  data = {"x" => 3, "y" => 2}
  DataStructureTree::construct_trees(data)
end

def construct_complex_data_tree
  data = {"x" => {"a" => 2.0, "b" => 3.0}}
  DataStructureTree::construct_trees(data)
end

# Simple Example of parallel mult and add operation on the same variable
def simple_tree
  print_titel "Test - Simple - Direct"
  data_structure_trees, direct_access = construct_simple_data_tree

  activity_a = ProcessTree::Activity.new(false, "A", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Int::ADD, direct_access["x"], [1], Ops::Int::EVAL)
        ]
      )
    ]
  )
  activity_b = ProcessTree::Activity.new(false, "B", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Int::MULT, direct_access["x"], [direct_access["y"]], Ops::Int::EVAL)
        ]
      )
    ]
  )

  par = ProcessTree::ParallelGateway.new([activity_a, activity_b])

  compute(direct_access, par)
end

# Simple Example of parallel mult and add operation where A increments y that is used in B
def simple_tree_indirect
  print_titel "Test - Simple - Indirect"
  data_structure_trees, direct_access = construct_simple_data_tree

  activity_a = ProcessTree::Activity.new(false, "A", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Int::ADD, direct_access["y"], [1], Ops::Int::EVAL)
        ]
      )
    ]
  )
  activity_b = ProcessTree::Activity.new(false, "B", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Int::MULT, direct_access["x"], [direct_access["y"]], Ops::Int::EVAL)
        ]
      )
    ]
  )

  par = ProcessTree::ParallelGateway.new([activity_a, activity_b])

  compute(direct_access, par)
end

# Simple Example of parallel eq and add operation where A increments x that is used in B
def simple_tree_indirect_eq
  print_titel "Test - Simple - Indirect"
  data_structure_trees, direct_access = construct_simple_data_tree

  activity_a = ProcessTree::Activity.new(false, "A", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Int::ADD, direct_access["y"], [1], Ops::Int::EVAL)
        ]
      )
    ]
  )
  activity_b = ProcessTree::Activity.new(false, "B", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Int::EQUAL, direct_access["x"], [direct_access["y"]], Ops::Int::EVAL)
        ]
      )
    ]
  )

  par = ProcessTree::ParallelGateway.new([activity_a, activity_b])

  compute(direct_access, par)
end

def simple_tree_indirect_swap
  print_titel "Test - Simple - Indirect - Swap"
  data_structure_trees, direct_access = construct_simple_data_tree

  activity_a = ProcessTree::Activity.new(false, "A", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Int::ADD, direct_access["y"], [1], Ops::Int::EVAL)
        ]
      )
    ]
  )
  activity_b = ProcessTree::Activity.new(false, "B", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Int::MULT, direct_access["x"], [direct_access["y"]], Ops::Int::EVAL)
        ]
      )
    ]
  )

  par = ProcessTree::ParallelGateway.new([activity_b, activity_a])

  compute(direct_access, par)
end

# Conflicts A-B A-C
def simple_tree_three
  print_titel "Test - Simple - Three Activities"
  data_structure_trees, direct_access = construct_simple_data_tree

  activity_a = ProcessTree::Activity.new(false, "A", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Int::ADD, direct_access["y"], [1], Ops::Int::EVAL)
        ]
      )
    ]
  )
  activity_b = ProcessTree::Activity.new(false, "B", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Int::MULT, direct_access["x"], [direct_access["y"]], Ops::Int::EVAL)
        ]
      )
    ]
  )
  activity_c = ProcessTree::Activity.new(false, "C", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Int::MULT, direct_access["x"], [direct_access["y"]], Ops::Int::EVAL)
        ]
      )
    ]
  )

  par = ProcessTree::ParallelGateway.new([activity_a, activity_b, activity_c])

  compute(direct_access, par)
end


# Conflicts A-B A-C B-C
def simple_tree_three_conflict
  print_titel "Test - Simple - Three Activities Conflicting"
  data_structure_trees, direct_access = construct_simple_data_tree

  activity_a = ProcessTree::Activity.new(false, "A", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Int::ADD, direct_access["y"], [1], Ops::Int::EVAL)
        ]
      )
    ]
  )
  activity_b = ProcessTree::Activity.new(false, "B", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Int::MULT, direct_access["x"], [direct_access["y"]], Ops::Int::EVAL)
        ]
      )
    ]
  )
  activity_c = ProcessTree::Activity.new(false, "C", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Int::ADD, direct_access["x"], [direct_access["y"]], Ops::Int::EVAL)
        ]
      )
    ]
  )

  par = ProcessTree::ParallelGateway.new([activity_a, activity_b, activity_c])

  compute(direct_access, par)
end

# BC are in sequence so no longer in contention
def simple_tree_three_seq_bc
  print_titel "Test - Simple - Three Activities Sequence BC"
  data_structure_trees, direct_access = construct_simple_data_tree

  activity_a = ProcessTree::Activity.new(false, "A", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Int::ADD, direct_access["y"], [1], Ops::Int::EVAL)
        ]
      )
    ]
  )
  activity_b = ProcessTree::Activity.new(false, "B", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Int::MULT, direct_access["x"], [direct_access["y"]], Ops::Int::EVAL)
        ]
      )
    ]
  )
  activity_c = ProcessTree::Activity.new(false, "C", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Int::ADD, direct_access["x"], [direct_access["y"]], Ops::Int::EVAL)
        ]
      )
    ]
  )

  par = ProcessTree::ParallelGateway.new([activity_a, ProcessTree::SequenceGateway.new([activity_b, activity_c])])

  compute(direct_access, par)
end

# Added Choice
# BC are in choice so no longer in contention
def choice_tree_three_with_choice
  print_titel "Test - Simple - Choice"
  data_structure_trees, direct_access = construct_simple_data_tree

  activity_a = ProcessTree::Activity.new(false, "A", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Int::ADD, direct_access["y"], [1], Ops::Int::EVAL)
        ]
      )
    ]
  )
  activity_b = ProcessTree::Activity.new(false, "B", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Int::MULT, direct_access["x"], [direct_access["y"]], Ops::Int::EVAL)
        ]
      )
    ]
  )
  activity_c = ProcessTree::Activity.new(false, "C", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Int::ADD, direct_access["x"], [direct_access["y"]], Ops::Int::EVAL)
        ]
      )
    ]
  )

  par = ProcessTree::ParallelGateway.new([activity_a, ProcessTree::ChoiceGateway.new(
    [activity_b, activity_c], 
    [ProgramConstructs::Statement.new([ProgramConstructs::Operation.new(Ops::Int::GT, direct_access["y"], [2], Ops::Int::EVAL)])]
  )])

  compute(direct_access, par)
end

# Simple Example of parallel mult and add operation on two different variables of a hash data structure
# No Conflict
def simple_tree_complex_data_no_conflict
  print_titel "Test - Simple - ComplexData - No Conflict"
  data_structure_trees, direct_access = construct_complex_data_tree
  
  activity_a = ProcessTree::Activity.new(false, "A", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Hash::RETR, direct_access["x"], ['a'], :empty),
          ProgramConstructs::Operation.new(Ops::Float::ADD, direct_access["x['a']"], [1.0], Ops::Float::EVAL)
        ]
      )
    ]
  )
  activity_b = ProcessTree::Activity.new(false, "B", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Hash::RETR, direct_access["x"], ['b'], :empty),
          ProgramConstructs::Operation.new(Ops::Float::MULT, direct_access["x['b']"], [2.0], Ops::Float::EVAL)
        ]
      )
    ]
  )

  par = ProcessTree::ParallelGateway.new([activity_a, activity_b])

  compute(direct_access, par)
end

# Simple Example of parallel mult and add operation on two different variables of a hash data structure
# Conflict: A-B on x['a']
def simple_tree_complex_data_conflict
  print_titel "Test - Simple - ComplexData - Conflict"
  data_structure_trees, direct_access = construct_complex_data_tree
  
  activity_a = ProcessTree::Activity.new(false, "A", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Hash::RETR, direct_access["x"], ['a'], :empty),
          ProgramConstructs::Operation.new(Ops::Float::ADD, direct_access["x['a']"], [1.0], Ops::Float::EVAL)
        ]
      )
    ]
  )
  activity_b = ProcessTree::Activity.new(false, "B", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Hash::RETR, direct_access["x"], ['b'], :empty),
          ProgramConstructs::Operation.new(Ops::Float::MULT, direct_access["x['b']"], [direct_access["x['a']"]], Ops::Float::EVAL)
        ]
      )
    ]
  )

  par = ProcessTree::ParallelGateway.new([activity_a, activity_b])

  compute(direct_access, par)
end

# Simple Example of parallel insert and equality operations operation on two different variables of a hash data structure
# No Conflict
def complex_op_complex_data_conflict
  print_titel "Test - Complex Operations - ComplexData - Conflict"
  data_structure_trees, direct_access = construct_complex_data_tree
  
  activity_a = ProcessTree::Activity.new(false, "A", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Hash::EQUAL, direct_access["x"], [  {"a" => 2.0, "b" => 3.0}  ], :empty)
        ]
      )
    ]
  )
  activity_b = ProcessTree::Activity.new(false, "B", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Hash::INS, direct_access["x"], ["test", 4], :empty)
        ]
      )
    ]
  )

  par = ProcessTree::ParallelGateway.new([activity_a, activity_b])

  compute(direct_access, par)
end

# Simple Example of parallel insert and equality operations operation on two different variables of a hash data structure
# No Conflict
def complex_insert_non_conflicting
  print_titel "Test - Inserts - ComplexData - Conflict"
  data_structure_trees, direct_access = construct_complex_data_tree
  
  activity_a = ProcessTree::Activity.new(false, "A", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Hash::INS, direct_access["x"], ["test2", 2], :empty)
        ]
      )
    ]
  )
  activity_b = ProcessTree::Activity.new(false, "B", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Hash::INS, direct_access["x"], ["test", 4], :empty)
        ]
      )
    ]
  )

  par = ProcessTree::ParallelGateway.new([activity_a, activity_b])

  compute(direct_access, par)
end

# Simple Example of parallel insert and equality operations operation on two different variables of a hash data structure
# No Conflict
def complex_insert_conflicting
  print_titel "Test - Simple - ComplexData - Conflict"
  data_structure_trees, direct_access = construct_complex_data_tree
  
  activity_a = ProcessTree::Activity.new(false, "A", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Hash::INS, direct_access["x"], ["test", 2], :empty)
        ]
      )
    ]
  )
  activity_b = ProcessTree::Activity.new(false, "B", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Hash::INS, direct_access["x"], ["test", 4], :empty)
        ]
      )
    ]
  )

  par = ProcessTree::ParallelGateway.new([activity_a, activity_b])

  compute(direct_access, par)
end

# Simple Example of parallel insert and equality operations operation on two different variables of a hash data structure
# No Conflict
def test_marking
  print_titel "Test - Marking - Conflict"
  data_structure_trees, direct_access = construct_complex_data_tree
  
  activity_a = ProcessTree::Activity.new(false, "A", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Hash::EQUAL, direct_access["x"], [  {"a" => 2.0, "b" => 3.0}  ], :empty)
        ]
      )
    ]
  )
  activity_b = ProcessTree::Activity.new(false, "B", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Hash::RETR, direct_access["x"], ['a'], :empty),
          ProgramConstructs::Operation.new(Ops::Float::ADD, direct_access["x['a']"], [4.0], Ops::Float::EVAL)
        ]
      )
    ]
  )

  par = ProcessTree::ParallelGateway.new([activity_a, activity_b])

  compute(direct_access, par)
end

# Simple Example of parallel insert and equality operations operation on two different variables of a hash data structure
# No Conflict
def test_marking_inverse
  print_titel "Test - Marking - Conflict - Inverse order"
  data_structure_trees, direct_access = construct_complex_data_tree
  
  activity_a = ProcessTree::Activity.new(false, "A", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Hash::EQUAL, direct_access["x"], [  {"a" => 2.0, "b" => 3.0}  ], :empty)
        ]
      )
    ]
  )
  activity_b = ProcessTree::Activity.new(false, "B", 
    [
      ProgramConstructs::Statement.new(
        [
          ProgramConstructs::Operation.new(Ops::Hash::RETR, direct_access["x"], ['a'], :empty),
          ProgramConstructs::Operation.new(Ops::Float::ADD, direct_access["x['a']"], [4.0], Ops::Float::EVAL)
        ]
      )
    ]
  )

  par = ProcessTree::ParallelGateway.new([activity_b, activity_a])

  compute(direct_access, par)
end

def compute(direct_access, process_tree)
  concurrency_candidates, activity_set = compute_concurrency_candidates(process_tree)
  set = identify_race_conditions(process_tree, concurrency_candidates, direct_access)

  print_titel("RESULT:")
  pp set
  pp "=" * 40
  puts "\n"*2
end

def print_titel(titel)
  print_sep
  pp titel
  print_sep
end

def print_sep() = pp "=" * 40



# Test Cases
simple_tree
simple_tree_indirect
simple_tree_indirect_eq
simple_tree_indirect_swap
simple_tree_three
simple_tree_three_conflict
simple_tree_three_seq_bc
choice_tree_three_with_choice
simple_tree_complex_data_no_conflict
simple_tree_complex_data_conflict

complex_op_complex_data_conflict
complex_insert_non_conflicting
complex_insert_conflicting
test_marking
test_marking_inverse
