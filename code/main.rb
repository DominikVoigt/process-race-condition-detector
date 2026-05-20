require "./data_structure_tree.rb"
require "./program_constructs.rb"
require "./concurrency_candidates.rb"
require "./race_condition.rb"

data = {"x" => 3, "y" => 2}
data_structure_trees, direct_access = DataStructureTree::construct_trees(data)

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
root = par

concurrency_candidates, activity_set = compute_concurrency_candidates(root)
identify_race_conditions(root, concurrency_candidates, direct_access)