# pagerank
_Ennova codetest response_

## Requirements
- MRI Ruby 1.9.3 (tested using -p547)
- celluloid
- rspec

## Comments
Seeing as this code isn't for production I took the opportunity to learn the basics of the Actor concurrency model using [*Celluloid*](https://github.com/celluloid/celluloid) and practice using git-flow.

Celluloid requires a Ruby engine running in 1.9 mode and while MRI Ruby doesn't support true parallelism due to the GIL, I guessed that there was a better chance of MRI Ruby 1.9.3 being present than JRuby or Rubinius.

I'm yet to research Ruby documentation styles, mine ranges from class responsibilty definitions to dev notes and logic stubs.

I noticed two errors in the problem description, both on the first page down the bottom in the examples. The two Page 3 strength ratings have been switched.

_Alex_

## Instructions
Don't forget to run `bundle` to ensure you've got everything.

Run `rspec` for testing results (yeah, the neat little row of dots is muddied by `PageRanker#service_query`).

or

Run the demo program:

    $ ruby demo.rb < sample_input.txt
Confirm that it's valid:

    $ ruby demo.rb < sample_input.txt > actual_output.txt
    $ diff actual_output.txt sample_output.txt
