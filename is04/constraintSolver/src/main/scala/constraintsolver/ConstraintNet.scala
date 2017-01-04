package com.contraintsolver



import constraints.ConstraintsImpl.Constraint
import constraints.Variable

import scala.annotation.tailrec


/**
 * Created by Allquantor on 13/12/14.
 */

case class ConstraintNet(var Constrains: Set[Constraint] = Set[Constraint](),
                         var Variables: Set[Variable] = Set[Variable]()) {


  def constraints = Constrains

  /**
   * helper method
   * find all neighbors of x
   *
   *
   * this method is used to update
   * the queue if vi change his domains
   * we need to update all 3tuples : (vi,vx,constraint),(vx,vi,constraint),(vi,vy,constraint)...(vi,vn,constraint)
   *
   * what we do is generate all neighbor tuples here first
   *
   * @param x = vi where domain values are change
   * @return all combinations of (neighbor,constraint)
   */

  def getNeighborsFor(x: Variable): List[(Variable, Constraint)] = {
    @tailrec
    def loop(constraints: List[Constraint], neighbours: List[(Variable, Constraint)]): List[(Variable, Constraint)] =
      constraints match {
        case c :: rest =>
          val (x1, x2) = c.variables
          if (x1 == x) loop(rest, (x2, c) :: neighbours)
          else if (x2 == x) loop(rest, (x1, c) :: neighbours)
          else loop(rest, neighbours)
        case Nil => neighbours
      }

    loop(Constrains.toList, Nil)
  }

  def addVariable(vars: Variable*) = {
    Variables ++ vars
  }

  def addConstrain(c: Constraint*) = {
    Constrains = Constrains ++ c
  }


}
