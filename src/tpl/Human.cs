namespace {{PJ}};
public class {{CLS}}
{
    public string Name { get; init; } = "名無しの権兵衛";
    public int Age { get; init; }
    public bool Valid() {
        if (this.Name.Length < 1 || 16 < this.Name.Length) { throw new ArgumentOutOfRangeException("Name", "名前は1〜16字以内であれ。"); }
        if (this.Age < 0 || 255 < this.Age) { throw new ArgumentOutOfRangeException("Age", "年齢は0〜255以内であれ。"); }
        return true;
    }
}

