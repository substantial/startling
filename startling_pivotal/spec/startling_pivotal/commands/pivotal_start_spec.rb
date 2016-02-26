require 'spec_helper'
require 'startling_pivotal/commands/pivotal_start'

module Startling
  module Commands
    describe PivotalStart do
      let(:story_id) { 12345 }
      let(:attrs) { { story_id: story_id } }
      let(:pivotal_start) { PivotalStart.new(attrs) }
      let(:user_id) { 456 }
      let(:story) do
        double(:story,
          name: 'Test story',
          estimated?: true,
          start: true
        )
      end

      before do
        allow(pivotal_start).to receive(:story) { story }
      end

      describe '#execute' do
        before do
          allow(Startling::Configuration).to receive(:load_configuration)
          allow(StartlingPivotal).to receive(:user_id) { user_id }
        end

        it 'loads the configuration' do
          expect(Startling::Configuration).to receive(:load_configuration)

          pivotal_start.execute
        end

        it 'asks for an estimate if the story is not estimated' do
          allow(story).to receive(:estimated?) { false }

          expect(pivotal_start).to receive(:ask_for_estimate) { 2 }

          pivotal_start.execute
        end

        it 'starts the story' do
          expect(story)
            .to receive(:start)
            .with(
              starter_ids: [user_id],
              estimate: nil
            )

          pivotal_start.execute
        end

        it 'returns the story' do
          expect(pivotal_start.execute).to eq(story)
        end
      end

      describe '#ask_for_estimate' do
        before do
          allow(StartlingPivotal).to receive(:valid_estimates) { [1, 2] }
        end

        it 'returns estimate if it is valid' do
          allow_any_instance_of(PivotalStart).to receive(:ask) { '1' }

          expect(pivotal_start.ask_for_estimate).to eq(1)
        end

        it 'prompts user for estimate until valid estimate entered' do
          allow_any_instance_of(PivotalStart)
            .to receive(:ask)
            .and_return('3', '2')

          expect(pivotal_start.ask_for_estimate).to eq(2)
        end
      end

      describe '#get_story_id' do
        context 'when story id is defined in command line options' do
          let(:attrs) { { story_id: 'clo' } }

          it 'returns the story id' do
            expect(pivotal_start.get_story_id).to eq('clo')
          end
        end

        context 'when there is at least one command line option' do
          let(:attrs) { { args: ['first-arg'], story_id: nil } }

          it 'returns the story id' do
            expect(pivotal_start.get_story_id).to eq('first-arg')
          end
        end

        context 'when story id is not specified' do
          let(:attrs) { { args: [], story_id: nil } }

          it 'prompts for story id' do
            allow_any_instance_of(PivotalStart).to receive(:ask) { '#123' }

            expect(pivotal_start.get_story_id).to eq('123')
          end

          it 'returns error message if no story id is entered in prompt' do
            allow_any_instance_of(PivotalStart).to receive(:ask) { '' }

            expect { pivotal_start.get_story_id }.to raise_exception(SystemExit)
          end
        end
      end
    end
  end
end
