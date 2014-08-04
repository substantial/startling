require 'paint'

# Refine the string class to have a interface similar to colored gem.

# Look @ https://github.com/janlelis/paint for a bunch of possible
# keywords

module TeachingChannelStart
  module ColorizeString
    refine String do
      COLORS = %i[
      black
      blue
      cyan
      green
      red
      white
      yellow
      ]

      EXTRAS = %i[
        bold
        bright
        clean
        conceal
        hide
        inverse
        nothing
        reset
        underline
        show
      ]

      COLORS.each do |color|
        define_method(color) do
          Paint[self, color]
        end

        define_method("on_#{color}") do
          Paint[self, nil, color]
        end

        COLORS.each do |highlight|
          next if color == highlight
          define_method("#{color}_on_#{highlight}") do
            Paint[self, color, highlight]
          end
        end
      end

      EXTRAS.each do|extra|
        define_method(extra) do
          Paint[self, extra]
        end
      end
    end
  end
end
