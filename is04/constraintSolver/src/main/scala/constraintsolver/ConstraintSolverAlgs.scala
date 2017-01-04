package constraintsolver

import com.contraintsolver.ConstraintNet
import constraints.ConstraintsImpl.Constraint
import constraints.Variable

import scala.annotation.tailrec

/**
 * Created by Allquantor on 14/12/14.
 *
 *
 */
object ConstraintSolverAlgs {

  /**
   * An helper method to generate queue for using in AC-X algorithms
   * The queue contains all constraints
   * @param constraintList constraint list for an given csp
   * @return a queue of 3tuples where for each node 2tuple(vi,vj) => 3tuple(vi,vj,constraint),3tuple(vj,vi,constraint)
   */

  private def _acPrepareQueue(constraintList: Set[Constraint]) = {
    var queue = List[(Variable, Variable, Constraint)]()
    constraintList.foreach(c => {
      val (vi, vj) = c.variables
      //queue = (vi, vj, c) ::(vj, vi, c) :: queue
      queue = (vi, vj, c) :: queue

    })
    queue
  }


  def ac3(csp: ConstraintNet): Option[ConstraintNet] = {


    @tailrec
    def _ac3(csp: ConstraintNet, queue: List[(Variable, Variable, Constraint)]): Option[ConstraintNet] = {

      /*

      Q <- {(Vi,Vj) in arcs(G),i#j};
      while not Q empty
      select and delete any arc (Vk,Vm) from Q;
      if REVISE(Vk,Vm) then
        Q <- Q union {(Vi,Vk) such that (Vi,Vk) in arcs(G),i#k,i#m}
      endif
      endwhile

      */

      queue match {
          // take the 3tuple(vertexI,vertexY,constraint)
        case (vi, vj, c) :: rest => {
          revise(vi, vj, c) match {
            case Some(newvi: Variable) if newvi.domains.nonEmpty => {
              val neighbors = csp.getNeighborsFor(newvi)
              var newqueue = rest
              neighbors.foreach(nbr => if (nbr._1 != vj) newqueue = (nbr._1, newvi, nbr._2) :: newqueue)
              _ac3(csp.copy(csp.Constrains, csp.Variables + newvi), newqueue)
            }
            case Some(newvi: Variable) if newvi.domains.isEmpty => None
            case None => {
              _ac3(csp, rest)
            }
          }
        }
          // queue is empty
        case Nil => Some(csp)
      }
    }
    _ac3(csp = csp, queue = _acPrepareQueue(csp.constraints))
  }


  /**
   * Basic algorithm for Arc consistency
   *
   * @param vi
   * @param vj
   * @param c constraint for test consistency
   * @return a modified version of vi without domain items which does not satisfied c(vi)
   */

  def revise(vi: Variable, vj: Variable, c: Constraint): Option[Variable] = {
    //todo this should be rethinked
    //require(vi == c.variables._1 && vj == c.variables._2)

    val domainVi = vi.domains
    val domainVj = vj.domains

    val modifiedDomainVi = domainVi.filter(ei => domainVj.find(ej => c.isSatisfied(ei, ej)).isDefined)


    if (modifiedDomainVi.size < domainVi.size) Some(vi.copy(vi.name, modifiedDomainVi))
    else None


  }

}
