require_relative "base"

module TeachingChannelStart
  module Commands
    class ThreeAmigos < Base
      using ColorizeString

      def execute
        puts
        puts "Time for 3 Amigos!!!"

        wiki_link =
          "https://github.com/TeachingChannel/teaching-channel/wiki/3-Amigos".underline
        puts "If you need more info, checkout: #{wiki_link}"
        puts
        puts "Three Amigo Guidelines".blue
        puts
        puts "1. What is the story and why are we doing it?".white
        puts "2. When is the story complete?".white
        puts "3. Can the story be broken down further?".white
        puts "4. Do we need to track anything for the epic's goals?".white

        question = [
          "Have these questions been answered (",
          'anything but "ole" will abort'.underline,
          ")? "
        ].map { |string| string.yellow }.join

        puts
        confirm = ask(question)

        exit unless confirm == "ole"
      end
    end
  end
end
