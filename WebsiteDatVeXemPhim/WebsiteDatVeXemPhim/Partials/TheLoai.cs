using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WebsiteDatVeXemPhim.Utils;

namespace WebsiteDatVeXemPhim.EF
{
    public partial class TheLoai
    {
        public enum statusTheLoai
        {
            DungChieu = 0,
            DangChieu = 1,
        }
        public class TheLoaiDTO
        {
            public int id { get; set; }
            public string TenTheLoai { get; set; }
            public string MoTa { get; set; }
            public int TinhTrang  { get; set; }
            public DateTime? NgayTao { get; set; }
            public string NgayTaoFormat
            {
                get
                {
                    return NgayTao == null ? "" : NgayTao.GetValueOrDefault().ToString("dd/MM/yyyy");
                }
            }
            public DateTime? NgayCapNhat { get; set; }
            public string NgayCapNhatFormat
            {
                get
                {
                    return NgayCapNhat == null ? "" : NgayCapNhat.GetValueOrDefault().ToString("dd/MM/yyyy");
                }
            }
          
        }
        public class JsonTheLoai
        {
            public object[] listLoaiPhim { get; set; }
        }

        public TheLoaiDTO CopyObjectForMovieType()
        {
            var kol_campaignDTO = new TheLoaiDTO();
            Utils.ObjectUtil.CopyPropertiesTo(this, kol_campaignDTO);
            return kol_campaignDTO;
        }
    }
}