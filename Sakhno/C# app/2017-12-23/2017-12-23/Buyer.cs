using Cassandra;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _2017_12_23
{
    public class Buyer
    {
        public int id;
        public String name;
        public float balance;
        //используется только для подведения топа юзеров
        public float sumPrice = 0;
        public int orderCnt = 0;

        public Buyer()
        {
        }
        public Buyer(int id, String name, float balance)
        {
            this.id = id;
            this.name = name;
            this.balance = balance;
        }
        public Buyer(String id, String name, String balance)
        {
            this.id = int.Parse(id);
            this.name = name;
            this.balance = float.Parse(balance);
        }

        public Buyer(Row row)
        {
            fromRow(row);
        }

        void fromRow(Row row)
        {
            id = (int)row["buyer_id"];
            name = (String)row["buyer_name"];
            balance = (float)row["buyer_balance"];
        }

        public String toJSON()
        {
            String result ="{";
            result += "\"buyer_id\":" + id + ",";
            result += "\"buyer_name\":\"" + name + "\",";
            result += "\"buyer_balance\":" + balance.ToString().Replace(',', '.');
            result += "}";
            return result;
        }

        public override String ToString()
        {
            return id + ") " + name + " [" + balance + "]";
        }
    }
    
}
