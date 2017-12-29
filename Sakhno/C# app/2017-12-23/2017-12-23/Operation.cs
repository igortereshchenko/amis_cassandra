using Cassandra;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _2017_12_23
{
    public class Operation
    {
        public int id;
        public String date;
        public String name;
        public int count;
        public float price;
        public String warehouse;
        public String producer;
        public int buyer_id;

        public Operation()
        {
        }
        public Operation(int id, String date, String name, int count, float price, String warehouse, String producer, int buyer_id)
        {
            this.id= id;
            this.date= date;
            this.name= name;
            this.count= count;
            this.price= price;
            this.warehouse= warehouse;
            this.producer= producer;
            this.buyer_id= buyer_id;
        }

        public Operation(String id, String date, String name, String count, String price, String warehouse, String producer, Buyer buyer)
        {
            this.id = int.Parse(id);
            this.date = date;
            this.name = name;
            this.count = int.Parse(count);
            this.price = float.Parse(price);
            this.warehouse = warehouse;
            this.producer = producer;
            this.buyer_id = buyer.id;
        }

        public Operation(Row row)
        {
            fromRow(row);
        }

        void fromRow(Row row)
        {
            id = (int)row["operation_id"];
            date = row["operation_date"].ToString();
            name = (String)row["product_name"];
            count = (int)row["product_count"];
            price = (float)row["product_price"];
            warehouse = (String)row["wh_name"];
            producer = (String)row["producer_name"];
            if (row["buyer_id"] != null)
                buyer_id = (int)row["buyer_id"];
        }

        public String toJSON()
        {

            /*	"operation_id": 5,
                "operation_date": "2017-12-24",
                "product_name": "Морква",
                "product_count": 99,
                "product_price": 20,
                "wh_name": "АТБ",
                "producer_name": null,
                "buyer_id": 2*/
            String result ="{";
            result += "\"operation_id\":" + id + ",";
            result += "\"operation_date\":\"" + date + "\",";
            result += "\"product_name\":\"" + name + "\",";
            result += "\"product_count\":\"" + count + "\",";
            result += "\"product_price\":\"" + price.ToString().Replace(',','.') + "\",";
            result += "\"wh_name\":\"" + warehouse + "\",";
            result += "\"producer_name\":\"" + producer + "\",";
            result += "\"buyer_id\":" + buyer_id;
            result += "}";
            return result;
        }

        public override String ToString()
        {
            return id + ") " + 
                (price > 0?"Продаж ":(price == 0?"Бажає купити":"Поставка ")) +
                Math.Abs(count) + " " + 
                name +
                "  (Дата: " + date + ", " +
                "Ціна: " + Math.Abs(price) + " грн, " +
                "Склад: " + warehouse + ", " +
                (price>=0?"Покупець: " + buyer_id:"Постачальник: " + producer) + ")";
        }
    }
}
