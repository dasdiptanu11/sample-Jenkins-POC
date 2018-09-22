using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App.Business {
    /// <summary>
    /// contains Brand Manufacturer  properties
    /// </summary>
    public class Brand_ManufactureList : tbl_DeviceBrand {

        /// <summary>
        /// Device BrandId
        /// </summary>
        public int? DeviceBrandId { get; set; }

        /// <summary>
        /// Device Brand Description
        /// </summary>
        public String DeviceBrandDescription { get; set; }

        /// <summary>
        /// Device Manufacturer Id
        /// </summary>
        public int? DeviceManufacturerId { get; set; }

        /// <summary>
        /// Device Manufacturer Description
        /// </summary>
        public String DeviceManufacturerDescription { get; set; }

    }
}
