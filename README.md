Quine Central
=============

This is a Haskell program that generates a Haskell program that prints out a Perl program that prints out a Python program that prints out a Ruby program that prints out a C program that prints out a Java program that prints out a Rust program that prints out an OCaml program that prints out a Swift program that prints out a Racket program that prints out a Javascript program that prints out the first Haskell program generated.

However, you can configure it yourself to use any sequence of languages from the ones it knows. Any non-empty list of languages will do, including length one. You may start hitting language line length limits if you make your list too long. Note that you can repeat languages so you can give someone some Haskell which decays into Perl after n iterations. You can also generate ordinary single-language quines.

I've only tested it under MacOS X. I don't know if there are carriage return/linefeed issues with other OSes.

Change the list of languages in `lang` if you want a different sequence of languages.

Some more detailed instructions
-------------------------------
If you're running under Linux or OSX and have interpreters for all of the relevant languages installed then you can use `bash test.sh` on the command line. Chances are you don't have them all installed.

To start you can install the Haskell compiler GHC. There are many websites that discuss this. Once you have that installed you should have a command `runghc` in your path. Then you can type `runghc quineCentral.hs` on the command line. The output will be the quine itself. Save that output to a file, maybe with the name `quine.hs`. Now you can run that with `runghc quine.hs`. The output will be a ruby program. Save it as `quine.rb`. Install ruby. Now you can run `ruby quine.rb`. And now just keep going. But it's easier to install compilers for all of the languages and run `test.sh`. 

If you're having trouble installing all of the compilers and interpreters, modify lines 3 onwards in `quineCentral.hs` so the list only includes languages you do have installed. You can tweak `test.sh` to match.
