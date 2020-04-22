package coconut.react.macros;

class Helpers {

  static public function toComplex(cls:ClassType)
    return TPath(cls.name.asTypePath([for (p in cls.params) TPType(p.name.asComplexType())]));

  static public function parametrize(m:Member, self:ClassType)
    m.getFunction().sure().params = [for (p in self.params) p.toDecl()];
}