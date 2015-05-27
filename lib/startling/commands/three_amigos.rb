require_relative "base"

module Startling
  module Commands
    class ThreeAmigos < Base
      using ColorizeString

      def execute
        wiki_link =
          "https://github.com/TeachingChannel/teaching-channel/wiki/3-Amigos".underline.blue

        guidelines = [
          "1. What is the story and why are we doing it?",
          "2. When is the story complete?",
          "3. Can the story be broken down further?",
          "4. Do we need to track anything for the epic's goals?",
        ].join("\n")

        question = [
          "Have these questions been answered (".yellow,
          'anything but "ole" will abort'.underline.yellow,
          ")? ".yellow
        ].join

        puts
        puts "Time for 3 Amigos!!!"
        puts "If you need more info, checkout: #{wiki_link}"
        puts
        puts "Three Amigo Guidelines".white
        puts
        puts guidelines.blue
        puts

        confirm = ask(question)
        exit unless confirm == "ole"
      end
    end
  end
end
