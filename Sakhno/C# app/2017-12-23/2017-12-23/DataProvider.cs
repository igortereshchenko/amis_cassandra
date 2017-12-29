using Cassandra;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _2017_12_23
{
    class DataProvider
    {
        private static ConsistencyLevel consistency = ConsistencyLevel.LocalQuorum;
        public static List<Buyer> getBuyers(ISession session)
        {
            List<Buyer> result = new List<Buyer>();
            RowSet rows = session.Execute("select * from buyer", consistency);
            foreach (Row row in rows)
            {
                Buyer buyer = new Buyer(row);
                result.Add(buyer);
            }

            //sort
            for (int i = 0; i < result.Count; i++)
            {
                for (int j = 0; j < result.Count - 1; j++)
                {
                    if (result[j].id > result[j + 1].id)
                    {
                        Buyer tmp = result[j];
                        result[j] = result[j+1];
                        result[j + 1] = tmp;
                    }
                }
            }
            return result;
        }
        public static int getMaxBuyerId(ISession session)
        {
            List<Buyer> result = getBuyers(session);
            int max = 0;
            foreach(Buyer buyer in result){
                if (buyer.id > max)
                    max = buyer.id;
            }
            return max;
        }

        //UPDATE
        public static void addBuyer(ISession session, Buyer buyer)
        {
            String request = "INSERT INTO buyer JSON '" + buyer.toJSON() + "';";
            session.Execute(request, consistency);
        }


        public static void remBuyer(ISession session, int buyer_id)
        {
            String request = "delete from buyer where buyer_id =" + buyer_id + ";";
            session.Execute(request, consistency);
            //CASCADE
            //List<Operation> toDelete = getOperationsByBuyer(session, buyer_id);
            //foreach (Operation op in toDelete)
            //    remOperation(session, op.id);
        }


        public static List<Operation> getOperations(ISession session)
        {
            List<Operation> result = new List<Operation>();
            RowSet rows = session.Execute("select * from operations", consistency);
            foreach (Row row in rows)
            {
                Operation item = new Operation(row);
                result.Add(item);
            }

            //sort
            for (int i = 0; i < result.Count; i++)
            {
                for (int j = 0; j < result.Count - 1; j++)
                {
                    if (result[j].id > result[j + 1].id)
                    {
                        Operation tmp = result[j];
                        result[j] = result[j + 1];
                        result[j + 1] = tmp;
                    }
                }
            }
            return result;
        }
        public static List<Operation> getOperationsByBuyer(ISession session, int buyer_id)
        {
            List<Operation> result = new List<Operation>();
            RowSet rows = session.Execute("select * from operations where buyer_id = " + buyer_id, consistency);
            foreach (Row row in rows)
            {
                Operation item = new Operation(row);
                result.Add(item);
            }
            return result;
        }
        public static int getMaxOperationId(ISession session)
        {
            List<Operation> result = getOperations(session);
            int max = 0;
            foreach (Operation buyer in result)
            {
                if (buyer.id > max)
                    max = buyer.id;
            }
            return max;
        }

        public static void addOperation(ISession session, Operation operation)
        {
            String request = "INSERT INTO operations JSON '" + operation.toJSON() + "';";
            session.Execute(request, consistency);
        }

        public static void remOperation(ISession session, int operation_id)
        {
            String request = "delete from operations where operation_id =" + operation_id + ";";
            session.Execute(request, consistency);
        }
    }
}
