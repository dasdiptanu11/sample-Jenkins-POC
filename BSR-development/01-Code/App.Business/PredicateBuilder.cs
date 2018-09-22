using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;

namespace App.Business
{
   public static class PredicateBuilder
   {
       public static Expression> Make() { return null; }
 
       public static Expression> Make(this Expression> predicate)
       {
          return predicate;
        }
 
      public static Expression> Or(this Expression> expr, Expression> or)
      {
          if (expr == null) return or;
          var invokedExpr = Expression.Invoke(or, expr.Parameters.Cast());
          return Expression.Lambda>(Expression.Or(expr.Body, invokedExpr), expr.Parameters);
      }
 
      public static Expression> And(this Expression> expr, Expression> and)
      {
         if (expr == null) return and;
         var invokedExpr = Expression.Invoke(and, expr.Parameters.Cast());
         return Expression.Lambda>(Expression.And(expr.Body, invokedExpr), expr.Parameters);
       }
   }
}
