using Cassandra;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace _2017_12_23
{
    public partial class Buyers_List : Form
    {
        ISession session = null;
        Form1 form1 = null;

        public Buyers_List(ISession session, Form1 form1)
        {
            InitializeComponent();
            this.session = session;
            this.form1 = form1;
        }

        private void buttonLoadBuyers_Click(object sender, EventArgs e)
        {
            try
            {
                listBoxBuyerList.Items.Clear();
                listBoxBuyerList.Items.AddRange(DataProvider.getBuyers(session).ToArray());
            }
            catch (Exception exc)
            {
                MessageBox.Show("Error: " + exc);
            }
        }

        private void buttonAddBuyer_Click(object sender, EventArgs e)
        {
            new AddBuyer(session).Show();
        }

        private void buttonLoadBuyerOrders_Click(object sender, EventArgs e)
        {
            try{
                if(listBoxBuyerList.SelectedItem == null)
                    return;
                Buyer selected = (Buyer)listBoxBuyerList.SelectedItem;

                form1.listBoxOrders.Items.Clear();
                form1.listBoxOrders.Items.AddRange(DataProvider.getOperationsByBuyer(session, selected.id).ToArray());
            }
            catch (Exception exc)
            {
                MessageBox.Show("Error: " + exc);
            }
        }

        private void buttonAddOrder_Click(object sender, EventArgs e)
        {
            if(listBoxBuyerList.SelectedItem == null)
                return;
            Buyer selected = (Buyer)listBoxBuyerList.SelectedItem;
            new AddOrder(session, selected).Show();
        }

        private void buttonUpdateBuyer_Click(object sender, EventArgs e)
        {

            if (listBoxBuyerList.SelectedItem == null)
                return;
            Buyer selected = (Buyer)listBoxBuyerList.SelectedItem;
            new AddBuyer(session, selected).Show();
        }

        private void buttonRemoveBuyer_Click(object sender, EventArgs e)
        {
            try
            {
                if (listBoxBuyerList.SelectedItem == null)
                    return;
                Buyer selected = (Buyer)listBoxBuyerList.SelectedItem;

                DataProvider.remBuyer(session, selected.id);

                listBoxBuyerList.Items.Clear();
                listBoxBuyerList.Items.AddRange(DataProvider.getBuyers(session).ToArray());
            }
            catch (Exception exc)
            {
                MessageBox.Show("Error: " + exc);
            }
        }

        private void buttonGetTopBuyers_Click(object sender, EventArgs e)
        {
            try
            {
                //clear list
                listBoxBuyerList.Items.Clear();
                Application.DoEvents();
                
                //load buyers
                List<Buyer> buyers = DataProvider.getBuyers(session);

                //fill buyers stat
                foreach (Buyer buyer in buyers)
                {
                    List<Operation> operations = DataProvider.getOperationsByBuyer(session, buyer.id);
                    foreach (Operation operation in operations)
                    {
                        buyer.orderCnt++;
                        buyer.sumPrice += operation.price;
                    }
                }
                //sort
                for (int i = 0; i < buyers.Count; i++)
                {
                    for (int j = 0; j < buyers.Count - 1; j++)
                    {
                        if (buyers[j].sumPrice < buyers[j + 1].sumPrice)
                        {
                            Buyer tmp = buyers[j];
                            buyers[j] = buyers[j + 1];
                            buyers[j + 1] = tmp;
                        }
                    }
                }

                //show results
                foreach (Buyer buyer in buyers)
                    listBoxBuyerList.Items.Add("User " + buyer.id + " (" + buyer.name + ") made " + buyer.orderCnt + " orders, sum price = " + buyer.sumPrice );
            }
            catch (Exception exc)
            {
                MessageBox.Show("Error: " + exc);
            }
        }
    }
}
