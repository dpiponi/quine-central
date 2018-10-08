Quine Central
=============

This is a Haskell program that generates a Haskell program that prints out a Perl program that prints out a Python program that prints out a Ruby program that prints out a C program that prints out a Java program that prints out a Rust program that prints out an OCaml program that prints out a Swift program that prints out a Racket program that prints out a Javascript program that prints out the first Haskell program generated.

However, you can configure it yourself to use any sequence of languages from the ones it knows. Any non-empty list of languages will do, including length one. You may start hitting language line length limits if you make your list too long. Note that you can repeat languages so you can give someone some Haskell which decays into Perl after n iterations. You can also generate ordinary single-language quines.

I've only tested it under MacOS X. I don't know if there are carriage return/linefeed issues with other OSes.

Change the list of languages in `lang` if you want a different sequence of languages.
