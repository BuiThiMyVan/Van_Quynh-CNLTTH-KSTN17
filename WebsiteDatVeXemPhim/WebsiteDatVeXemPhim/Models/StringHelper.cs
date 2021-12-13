using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebsiteDatVeXemPhim.Models
{
    public static class StringHelper
    {
        public static string GenerateFullNameShotFromFullName(string fullName)
        {
            try
            {
                if (string.IsNullOrEmpty(fullName))
                {
                    return fullName;
                }
                string name = fullName.Trim();
                string[] words = name.ToUpper().Split(' ');
                string str = "";
                for (int i = 0; i < words.Length; i++)
                {
                    if (i == (words.Length - 1))
                    {
                        str = str + words[i][0];
                    }
                    else
                    {
                        str = str + words[i][0] + ".";
                    }
                }
                return str;
            }
            catch (Exception e)
            {

            }
            return null;
        }

        /// <summary>
        /// Rút gọn tên Seller trong tin nhắn đối với hợp đồng hết hạn
        /// </summary>
        /// <returns></returns>
        public static string ShortMessage(string messageContent)
        {
            string result = messageContent;
            try
            {
                int index = messageContent.IndexOf(":");
                if (index > -1)
                {
                    string fullName = messageContent.Substring(0, index);
                    if (fullName == "CSKH")
                    {
                        return result;
                    }
                    var shortName = GenerateFullNameShotFromFullName(fullName);
                    string content = messageContent.Substring(index + 2);
                    result = $"{shortName}: {content}";
                }
            }
            catch (Exception e)
            {

            }
            return result;
        }
        private static string RandomString(int length, bool isContainNumber, bool isOnlyNumber)
        {
            string result = "";
            try
            {
                Random random = new Random();
                string chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
                if (isContainNumber)
                {
                    chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
                }

                if (isOnlyNumber)
                {
                    chars = "1234567890";
                }
                result = new string(Enumerable.Repeat(chars, length).Select(s => s[random.Next(s.Length)]).ToArray());
            }
            catch (Exception e)
            {
            }
            return result;
        }

        public static string KeyGenerator()
        {
            string result = "";
            string text1 = RandomString(10, true, false);
            string text2 = RandomString(5, true, true);
            string text3 = RandomString(8, true, false);
            string text4 = RandomString(5, true, true);
            string text5 = RandomString(2, true, true);
            return $"{text1}-{text2}-{text3}-{text4}--{text5}";
        }

        public static string ConvertVN(this string chucodau)
        {
            try
            {
                const string FindText = "áàảãạâấầẩẫậăắằẳẵặđéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵÁÀẢÃẠÂẤẦẨẪẬĂẮẰẲẴẶĐÉÈẺẼẸÊẾỀỂỄỆÍÌỈĨỊÓÒỎÕỌÔỐỒỔỖỘƠỚỜỞỠỢÚÙỦŨỤƯỨỪỬỮỰÝỲỶỸỴ";
                const string ReplText = "aaaaaaaaaaaaaaaaadeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyAAAAAAAAAAAAAAAAADEEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOOOUUUUUUUUUUUYYYYY";
                int index = -1;
                char[] arrChar = FindText.ToCharArray();
                while ((index = chucodau.IndexOfAny(arrChar)) != -1)
                {
                    int index2 = FindText.IndexOf(chucodau[index]);
                    chucodau = chucodau.Replace(chucodau[index], ReplText[index2]);
                }
                return chucodau;
            }
            catch (Exception e)
            {

            }
            return chucodau;
        }
    }
}