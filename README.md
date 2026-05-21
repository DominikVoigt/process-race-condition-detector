# process-race-condition-detector

## Introduction

This repository contains the code associated with the paper "Data-aware Process Trees for Race Condition Detection in Concurrent Processes"

The Code to compute concurrency candidates can be found in [`concurrency_candidates.rb`](./code/concurrency_candidates.rb).
The Code to compute the race condition pairs can be found in [`race_condition.rb`](./code/race_condition.rb).
The Code that computes whether operations are conflicting can be found in [`program_constructs.rb`](./code/program_constructs.rb).

A set of test cases can be found here [`tests.rb`](./code/tests.rb).

To run the test cases, please go into the `code` subdirectory and execute `ruby ./tests.rb`