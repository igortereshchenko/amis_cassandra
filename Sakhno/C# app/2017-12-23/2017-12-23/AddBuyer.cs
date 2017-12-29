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
    public partial class AddBuyer : Form
    {
        ISession session = null;
        public AddBuyer(ISession in_session)
        {
            InitializeComponent();
            session = in_session;
        }
        public AddBuyer(ISession in_session, Buyer buyer)
        {
            InitializeComponent();
            session = in_session;
            textBoxBuyerID.Enabled = false;
            textBoxBuyerID.Text = buyer.id.ToString();
            buttonCalculateBuyerId.Enabled = false;
            textBoxBuyerBalance.Text = buyer.balance.ToString();
            textBoxBuyerName.Text = buyer.name;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            //INSERT INTO buyer JSON 
            //'{ 
            //    "buyer_id":1,
            //    "buyer_name":"Buyer2",
            //    "buyer_balance": 200.0 
            //}';

            try
            {
                String id = textBoxBuyerID.Text;
                String balance = textBoxBuyerBalance.Text.Replace('.', ',');
                String name = textBoxBuyerName.Text;
                Buyer buyer = new Buyer(id, name, balance);
                DataProvider.addBuyer(session, buyer);
                Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex);
            }

        }

        private void AddBuyer_Load(object sender, EventArgs e)
        {

        }

        private void buttonCalculateBuyerId_Click(object sender, EventArgs e)
        {
            try
            {
                textBoxBuyerID.Text = (DataProvider.getMaxBuyerId(session) + 1).ToString();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex);
            }
        }
    }
}
