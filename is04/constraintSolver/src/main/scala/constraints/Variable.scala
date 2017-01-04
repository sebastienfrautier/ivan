package constraints

/**
 * Created by Allquantor on 14/12/14.
 */
case class Variable(name:String,domains:Set[Int]) {

  override def equals(o:Any):Boolean = {
    o match {
      case that: Variable => that.name.equals(this.name)
      case _ => false
    }
  }

  override def hashCode = name.toUpperCase.hashCode

}
