
require "./process_tree.rb"

def compute_concurrency_candidates(node)
  if node.is_a?(ProcessTree::Activity)
    if node.is_tau?
      return [{}, Set.new]
    end
    map = {}
    map[node] = Set.new
    return [map, Set[node]]
  end

  

  # Node is a gateway
  children = node.children
  child_maps = []
  child_activity_sets = []
  children.each do |child|
    child_res = compute_concurrency_candidates(child) 
    child_maps << child_res[0]
    child_activity_sets << child_res[1] 
  end

  if node.is_a?(ProcessTree::ParallelGateway)
    # For each other subtree,
    child_maps.each_with_index do |child, idx|
      # Add activities to other trees as concurrent activities for each activity
      child.keys.each do |activity|
        child_activity_sets.each_with_index do |other, o_idx|
          if idx == o_idx
            next
          else
            child[activity].merge child_activity_sets[o_idx] 
          end
        end 
      end  
    end
  end
  activity_set = Set.new
  child_activity_sets.each do |child_activity_set|
    activity_set.merge child_activity_set
  end
  map = {}
  child_maps.each do |child_map|
    map = map.merge child_map
  end
  # Since Choice and Loops contain statements, we need to add them to the "activity set" nad the map
  if node.is_a?(ProcessTree::ChoiceGateway) || node.is_a?(ProcessTree::LoopGateway)
    map[node] = Set.new    
    activity_set.add node
  end
  
  return [map, activity_set]
end

def print_res(res)
  print "Concurrency Candidate map: \n #{res[0]}\n"
  print "Activities in Subtree: \n#{res[1]}\n"
end

def print_separator(title)
  space = 40
  sep = "="
  left = (space - title.length) / 2
  right = space - left - title.length 
  print sep * space + "\n"
  print " " * left + title + " " * right + "\n"
  print sep * space + "\n"
end

# print_separator("Single Activity Test")
# simple_res = compute_concurrency_candidates(ProcessTree::Activity.new(false, "test", []))
# print_res(simple_res)

# activity_a = ProcessTree::Activity.new(false, "A", [])
# activity_b = ProcessTree::Activity.new(false, "B", [])
# activity_c = ProcessTree::Activity.new(false, "C", [])
# activity_tau = ProcessTree::Activity.new(true, "", [])
# print_separator("Sequence Tests")
# seq = ProcessTree::SequenceGateway.new([activity_a,activity_b])
# complex_res_seq1 = compute_concurrency_candidates(seq)
# print_res(complex_res_seq1)
# seq2 = ProcessTree::SequenceGateway.new([activity_c,activity_tau])
# complex_res_seq2 = compute_concurrency_candidates(seq2)
# print_res(complex_res_seq2)

# print_separator("Parallel Tests")
# par = ProcessTree::ParallelGateway.new([seq, seq2])
# complex_res_par = compute_concurrency_candidates(par)
# print_res(complex_res_par)


# par_child = ProcessTree::ParallelGateway.new([activity_a, activity_b])
# par2 = ProcessTree::ParallelGateway.new([par_child, activity_c])
# complex_res_par2 = compute_concurrency_candidates(par2)
# print_res(complex_res_par2)
