module TaskBench
  class DummyTask < Actions::EntryAction
    def humanized_output
      "Dummy Task"
    end
    def plan(sleep_seconds=nil)
      plan_self(:sleep_seconds => sleep_seconds)
    end

    def run
      if input[:sleep_seconds]
        sleep input[:sleep_seconds]
      end
    end
  end
end