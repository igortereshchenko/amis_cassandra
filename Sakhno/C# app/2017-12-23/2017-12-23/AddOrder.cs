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
    public partial class AddOrder : Form
    {
        ISession session = null;
        Buyer buyer = null;
        public AddOrder(ISession session, Buyer buyer)
        {
            InitializeComponent();
            this.session = session;
            this.buyer = buyer;
            textBoxBuyerID.Text = buyer.ToString();
            textBoxProductProducer.Enabled = false;
            textBoxProductPrice.Text = "1";
            textBoxProductCount.Text = "1";//-
            Text = "Покупка додати";
        }
        public AddOrder(ISession session, Operation operation)
        {
            InitializeComponent();
            this.session = session;
            this.buyer = new Buyer();
            buyer.id = operation.id;
            textBoxBuyerID.Text = buyer.ToString();
            textBoxProductProducer.Enabled = false;
            //incomplete
        }

        public AddOrder(ISession session)
        {
            InitializeComponent();
            this.session = session;
            this.buyer = null;
            textBoxBuyerID.Text = "not used for supply";
            textBoxProductProducer.Enabled = true;
            textBoxProductPrice.Text = "1";//-
            textBoxProductCount.Text = "1";
            Text = "Поставка додати";
        }

        private void buttonOperationDateFill_Click(object sender, EventArgs e)
        {
            textBoxOperationDate.Text =  DateTime.Now.ToString("yyyy-MM-dd");
        }

        private void buttonOperationIDCalculate_Click(object sender, EventArgs e)
        {
            textBoxOperationID.Text = (DataProvider.getMaxOperationId(session)+1).ToString();
        }

        private void buttonAddOrder_Click(object sender, EventArgs e)
        {
            try
            {
                Operation operation = new Operation();
                operation.id = int.Parse(textBoxOperationID.Text);
                operation.date = textBoxOperationDate.Text;
                operation.name = textBoxProductName.Text;
                operation.warehouse = textBoxWHName.Text;
                if (buyer == null)//поставка
                {
                    operation.producer = textBoxProductProducer.Text;
                    operation.price = float.Parse("-" + textBoxProductPrice.Text.Replace('.', ',').Replace('-', ' ').Trim());
                    operation.count = int.Parse(textBoxProductCount.Text);
                    
                }
                else//покупка
                {
                    operation.buyer_id = buyer.id;
                    operation.price = float.Parse(textBoxProductPrice.Text.Replace('.', ','));
                    operation.count = int.Parse("-" + textBoxProductCount.Text.Replace('-', ' ').Trim());
                    //update user balance
                    buyer.balance -= operation.price;
                    DataProvider.addBuyer(session, buyer);
                }

                DataProvider.addOperation(session, operation);
                Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex);
            }
        }

        private void buttonMultiply_Click(object sender, EventArgs e)
        {
            try { 
                String priceText = textBoxProductPrice.Text;
                String countText = textBoxProductCount.Text;
                float count = int.Parse(countText);
                float price = float.Parse(textBoxProductPrice.Text.Replace('.', ','));
                textBoxProductPrice.Text = (count * price).ToString();

            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex);
            }
        }
    }
}
