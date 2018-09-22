using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App.Business
{
    public class FavouriteDeviceList
    {
        /// <summary>
        /// Id of the Favourite Device
        /// </summary>
        public int FavDevId { get; set; }
        /// <summary>
        /// Id of the Parent Favourite Device
        /// </summary>
        public int? ParentFavDevId { get; set; }
        /// <summary>
        /// Procedure name of the Favourite Device
        /// </summary>
        public string Procedure { get; set; }
        /// <summary>
        /// Type of Operation where the Device is used
        /// </summary>
        public string Type { get; set; }
        /// <summary>
        /// Hospital Site Name where the Device is used
        /// </summary>
        public string Hospital { get; set; }
        /// <summary>
        /// Device Details of the Favourite Device
        /// </summary>
        public string DeviceDetail { get; set; }
    }
}
