import com.contraintsolver.ConstraintNet
import com.example.AC3.Constraint
import com.sun.org.apache.xpath.internal.operations.Variable
import constraints.ConstraintsImpl.Constraint
import constraints.Variable
import constraintsolver.ConstraintSolverAlgs
import org.scalatest._


class ConstraintSolverAlgsACSpec extends FlatSpec with Matchers {

  def genConstraint(rel: (Int,Int) => Boolean,varx:Variable,vary:Variable):Constraint = {
    new Constraint(varx,vary) {
      override def isSatisfied(vid: Int, vjd: Int): Boolean = rel(vid,vjd)
    }
  }

  val constraintSmallerAs = (vid:Int,vjd:Int) => vid < vjd
  val constraintSquare = (vid:Int,vjd:Int) => vid == vjd * vjd



  "ac algorithm " should "solve double equations " in {

    val constraintNet = new ConstraintNet()
    val domain = Set(0,1,2,3,4,5,6,7,8,9)
    val varX = Variable("X",domain)
    val varY = Variable("Y",domain)

    val constraint = genConstraint(constraintSquare,varX,varY)

    constraintNet.addVariable(varX,varY)
    constraintNet.addConstrain(constraint)

    val result = ConstraintSolverAlgs.ac3(constraintNet).get

    val equationResultX = Set(0,1,4,9)
    val equationResultY = Set(0,1,2,3)


    val equationVariable = result.Variables.find(variable => variable.domains == equationResultX)

    // they should exist
    equationVariable should be (defined)


    // they shouldNot be the Same
    //(equationVariable) shouldNot be equals(possibleNumVariable)


    println(s"The EquationResult  is : ${equationVariable.get}")


  }

}
