using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebsiteDatVeXemPhim.EF
{
    public partial class SuatChieu
    {
        public class SuatChieuDTO
        {
            public int id { get; set; }
            public int SuatChieu { get; set; }
          

        }
        public class JsonSuatChieu
        {
            internal LichChieu.LichChieuDTO[] listLichChieu;

            public object[] listSuatChieu { get; set; }
        }

        public SuatChieuDTO CopyObjectForMovieRoom()
        {
            var kol_campaignDTO = new SuatChieuDTO();
            Utils.ObjectUtil.CopyPropertiesTo(this, kol_campaignDTO);
            return kol_campaignDTO;
        }
    }
}