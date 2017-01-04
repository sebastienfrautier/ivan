package constraints

/**
 * Created by Allquantor on 14/12/14.
 */
object ConstraintsImpl {

  abstract class Constraint(vi: Variable, vj: Variable) {
    // helper method #fancystuff
    def variables = (vi, vj)

    def isSatisfied(vid: Int, vjd: Int): Boolean
  }

  class AllDiffConstraint(x1: Variable, x2: Variable) extends Constraint(x1, x2) {

    private def _condition = (x: Int, j: Int) => x != j

    override def isSatisfied(vid: Int, vjd: Int) = _condition(vid, vjd)
  }


}
