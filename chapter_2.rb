module A
  class Gear
    attr_reader :chainring, :cog
    def initialize(chainring, cog)
      @chainring = chainring
      @cog       = cog
    end

    def ratio
      chainring / cog.to_f
    end
  end
end

module B
  class Gear
    attr_reader :chainring, :cog, :rim, :tire
    def initialize(chainring, cog, rim, tire)
      @chainring = chainring
      @cog = cog
      @rim = rim
      @tire = tire
    end

    def ratio
      chainring / cog.to_f
    end

    def gear_inches
      ratio * (rim + tire * 2)
    end
  end
end

module C
  class Gear
    def initialize(chainring, cog)
      @chainring = chainring
      @cog       = cog
    end

    def ratio
      @chainring / @cog.to_f # <-- 破滅への道
    end
  end
end

module D
  class Gear
    attr_reader :chainring, :cog # <------
    def initialize(chainring, cog)
      @chainring = chainring
      @cog       = cog
    end

    def ratio
      chainring / cog.to_f
    end
  end
end

module E
  class Gear
    def initialize(chainring, cog)
      @chainring = chainring
      @cog       = cog
    end

    def ratio
      chainring / cog.to_f
    end

    private

    attr_reader :chainring, :cog # <------
  end
end

module F
  class ObscuringReferences
    attr_writer :data
    def initialize(data)
      @data = data
    end

    def diameters
      # 0はリム、1はタイヤ
      data.collect do |cell|
        cell[0] + (cell[1] * 2)
      end
      # ... インデックスで配列の値を参照するメソッドが他にもたくさん
    end
  end
end

class RevealingReferences
  attr_reader :wheels
  def initialize(data)
    @wheels = wheelify(data)
  end

  def diameters
    wheels.collect do |wheel|
      wheel.rim + (wheel.tire * 2)
    end
  end
  # ... これでだれでもwheelにrim/tireを送れる

  Wheel = Struct.new(:rim, :tire)

  def wheelify(data)
    data.collect do |cell|
      Wheel.new(cell[0], cell[1])
    end
  end
end
