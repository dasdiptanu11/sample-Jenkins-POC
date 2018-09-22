using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace App.Business {
    /// <summary>
    /// Contains Device List properties
    /// </summary>
    public class DeviceList {
        /// <summary>
        /// DeviceId of the Device
        /// </summary>
        public int? DeviceId { get; set; }

        /// <summary>
        /// DeviceId of the Device
        /// </summary>
        public String DeviceDescription { get; set; }

        /// <summary>
        /// Is Device Active
        /// </summary>
        public bool IsDeviceActive { get; set; }

        /// <summary>
        /// Device Type Id
        /// </summary>
        public int? DeviceTypeId { get; set; }

        /// <summary>
        /// Device Type Description
        /// </summary>
        public String DeviceTypeDescription { get; set; }

        /// <summary>
        /// Device Brand Id
        /// </summary>
        public int? DeviceBrandId { get; set; }

        /// <summary>
        /// Device Brand Description
        /// </summary>
        public String DeviceBrandDescription { get; set; }

        /// <summary>
        /// Is Device Brand Active
        /// </summary>
        public int IsBrandActive { get; set; }

        /// <summary>
        /// Device Model
        /// </summary>
        public String DeviceModel { get; set; }

        /// <summary>
        /// Device Manufacturer Id
        /// </summary>
        public int? DeviceManufacturerId { get; set; }

        /// <summary>
        /// Device Manufacturer Description
        /// </summary>
        public String DeviceManufacturerDescription { get; set; }

        /// <summary>
        /// Is Device Manufacturer is Active or not
        /// </summary>
        public int IsManufacturerActive { get; set; }

    }
}
