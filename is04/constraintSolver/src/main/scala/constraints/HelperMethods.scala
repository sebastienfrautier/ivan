package constraints

/**
 * Created by Allquantor on 13/12/14.
 */
object HelperMethods {

  def mycomb[T](n: Int, l: List[T]): List[List[T]] =
    n match {
      case 0 => List(List())
      case _ => for(el <- l;
                    sl <- mycomb(n-1, l dropWhile { _ != el } ))
      yield el :: sl
    }

  def comb[T](n: Int, l: List[T]): List[List[T]] = mycomb(n, l.distinct)

}
