using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace App {
    public static class Extensions {
        public static void With<T>(this T item, Action<T> work) {
            work(item);
        }
    }
}