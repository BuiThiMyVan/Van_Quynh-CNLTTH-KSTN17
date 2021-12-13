using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebsiteDatVeXemPhim.Models
{
    public class Pagination
    {
        public int page { get; set; }

        public int pageSize { get; set; }

        public string txtSearch { get; set; }
    }
}