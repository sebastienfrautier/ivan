import constraints.ConstraintsImpl.Constraint
import constraints.Variable
import constraintsolver.ConstraintSolverAlgs
import org.scalatest._
import org.scalatest.junit.JUnitRunner


class ConstraintSolverAlgsReviseSpec extends FlatSpec with Matchers {

  def genConstraint(rel: (Int,Int) => Boolean,varx:Variable,vary:Variable):Constraint = {
    new Constraint(varx,vary) {
      override def isSatisfied(vid: Int, vjd: Int): Boolean = rel(vid,vjd)
    }
  }

  val constraintSmallerAs = (vid:Int,vjd:Int) => vid < vjd
  val constraintSquare = (vid:Int,vjd:Int) => vid == vjd * vjd



  "revise function " should "revise all domain values which does not satisfy the constraint " in {

    val domainX = Set(1,2,3,4,5,6,7,8,9,0)
    val domainY = Set(5,6,7,8,9,0)

    val variableX = Variable("X",domainX)
    val variableY = Variable("Y",domainY)

    val cons = genConstraint(constraintSmallerAs,variableX,variableY)

    val rightResult = Set(1,2,3,4,5,6,7,8,0)

    val result = ConstraintSolverAlgs.revise(variableX,variableY,cons)

    // result should be found in this case
    result.isDefined should be (true)

    // intersection should be eql to rightResult
    (result.get.domains & rightResult) should be (rightResult)

  }
  //todo this should be rethinked
/*
  it should "fail if constraints does not have the same variables in revise method" in {
    val domainX = Set(1,2,3,4,5,6,7,8,9,0)
    val domainY = Set(5,6,7,8,9,0)

    val variableX = Variable("X",domainX)
    val variableY = Variable("Y",domainY)

    // the same domain value as Y but another name!
    val variableZ = Variable("Z",domainY)

    val cons = genConstraint(constraintSmallerAs,variableX,variableZ)

    a [IllegalArgumentException] shouldBe thrownBy{
      ConstraintSolverAlgs.revise(variableX,variableY,cons)
    }

    a [IllegalArgumentException] shouldBe thrownBy{
      ConstraintSolverAlgs.revise(variableY,variableX,cons)
    }

    a [IllegalArgumentException] shouldBe thrownBy{
      ConstraintSolverAlgs.revise(variableZ,variableX,cons)
    }

    a [IllegalArgumentException] shouldBe thrownBy{
      ConstraintSolverAlgs.revise(variableZ,variableY,cons)
    }



  }
  */

  it should "work with special cases" in {
    val domainX = Set(1,56,8,9,199,101354,223,0,-40)
    val domainY = Set(10000000,20000000,30000000,40000000)

    val variableX = Variable("X",domainX)
    val variableY = Variable("Y",domainY)

    val cons1 = genConstraint(constraintSmallerAs,variableX,variableY)
    val cons2 = genConstraint(constraintSmallerAs,variableY,variableX)

    val firstResult = ConstraintSolverAlgs.revise(variableX,variableY,cons1)

    // constraints have a direction equals should work with it
    cons1 shouldNot be equals(cons2)

    // because all domain values satisfied the constraint
    // this is important for ac-3 alg
    (firstResult) should be (None)

    val secondResult = ConstraintSolverAlgs.revise(variableY,variableX, cons2)
    // because no one domain val satisfy the constraint
    (secondResult.get.domains.size) should be(0)









  }

}
