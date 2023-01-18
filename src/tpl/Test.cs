namespace {{PJ}}.Test;

public class Tests
{
    [SetUp]
    public void Setup()
    {
    }

    [Test]
    public void TestNewSimple()
    {
        {{PJ}}.{{CLS}} ins = new();
        Assert.That(ins.Age, Is.EqualTo(0));
        Assert.That(ins.Name, Is.EqualTo("名無しの権兵衛"));
    }
    [Test]
    public void TestValidNameLenZero()
    {
        Assert.That(
            ()=>{ {{PJ}}.{{CLS}} ins = new(){Name=""}; ins.Valid(); },
            Throws
                .TypeOf<ArgumentOutOfRangeException>()
                .With.Message.EqualTo("名前は1〜16字以内であれ。 (Parameter 'Name')")
        );
    }
    [Test]
    public void TestValidAgeMinus()
    {
        Assert.That(
            ()=>{ {{PJ}}.{{CLS}} ins = new(){Age=-1}; ins.Valid(); },
            Throws
                .TypeOf<ArgumentOutOfRangeException>()
                .With.Message.EqualTo("年齢は0〜255以内であれ。 (Parameter 'Age')")
        );
    }
}

