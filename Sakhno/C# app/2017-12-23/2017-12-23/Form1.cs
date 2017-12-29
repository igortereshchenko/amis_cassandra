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
    public partial class Form1 : Form
    {
        ISession session = null;

        public Form1()
        {
            InitializeComponent();
        }
        private void buttonConnect_Click(object sender, EventArgs e)
        {
            String address = textBoxAddress.Text;
            try
            {
                Cluster cluster = Cluster.Builder().AddContactPoint(address).Build();
                session = cluster.Connect("bd");
                panelControls.Visible = true;
            }
            catch (Exception exc) {
                MessageBox.Show("Error connecting: " + exc);
            }
        }
        private void Form1_FormClosed(object sender, FormClosedEventArgs e)
        {
            if (session != null)
                session.Dispose();
        }
        private void buttonListOrders_Click(object sender, EventArgs e)
        {
            try
            {
                listBoxOrders.Items.Clear();
                listBoxOrders.Items.AddRange(DataProvider.getOperations(session).ToArray());
            }
            catch (Exception exc)
            {
                MessageBox.Show("Error: " + exc);
            }
        }

        private void buttonListBuyers_Click(object sender, EventArgs e)
        {
            new Buyers_List(session, this).Show();
        }

        private void buttonAddSupply_Click(object sender, EventArgs e)
        {
            new AddOrder(session).Show();
        }

        private void buttonRemOrder_Click(object sender, EventArgs e)
        {
            try
            {
                if (listBoxOrders.SelectedItem == null)
                    return;
                Operation selected = (Operation)listBoxOrders.SelectedItem;

                DataProvider.remOperation(session, selected.id);

                listBoxOrders.Items.Clear();
                listBoxOrders.Items.AddRange(DataProvider.getOperations(session).ToArray());
            }
            catch (Exception exc)
            {
                MessageBox.Show("Error: " + exc);
            }
        }

        private void buttonProductStat_Click(object sender, EventArgs e)
        {
            try
            {
                //clear list
                listBoxOrders.Items.Clear();
                Application.DoEvents();


                List<Operation> operations = DataProvider.getOperations(session);
                List<string> name = new List<string>();
                List<int> supply = new List<int>();
                List<int> wish = new List<int>();
                List<int> sell = new List<int>();
                List<int> remaining = new List<int>();

                foreach (Operation operation in operations)
                {
                    int index = name.IndexOf(operation.name);
                    if (index == -1)
                    {
                        name.Add(operation.name);
                        supply.Add(0);
                        wish.Add(0);
                        sell.Add(0);
                        remaining.Add(0);
                        index = name.Count - 1;
                    }
                    if (operation.price == 0)
                        wish[index] += operation.count;
                    else if (operation.price > 0)
                        sell[index] += operation.count;
                    else if (operation.price < 0)
                        supply[index] += operation.count;
                    remaining[index] += operation.count;
                }

                
                //sort
                for (int i = 0; i < remaining.Count; i++)
                {
                    for (int j = 0; j < remaining.Count - 1; j++)
                    {
                        if (remaining[j] < remaining[j + 1])
                        {
                            {
                                string tmp = name[j];
                                name[j] = name[j + 1];
                                name[j + 1] = tmp;
                            }
                            {
                                int tmp = supply[j];
                                supply[j] = supply[j+1];
                                supply[j + 1] = tmp;

                                tmp = wish[j];
                                wish[j] = wish[j + 1];
                                wish[j + 1] = tmp;

                                tmp = sell[j];
                                sell[j] = sell[j + 1];
                                sell[j + 1] = tmp;

                                tmp = remaining[j];
                                remaining[j] = remaining[j + 1];
                                remaining[j + 1] = tmp;
                            }
                        }
                    }
                }

                for (int i = 0; i < name.Count; i++)
                {
                    listBoxOrders.Items.Add("Залишок: " + remaining[i] + " " + name[i] + 
                        " (Продано: " + Math.Abs(sell[i]) +
                        ", Поставок: " + Math.Abs(supply[i]) +
                        ", Бажають купити: " + Math.Abs(wish[i]) + ")");
                }
            }
            catch (Exception exc)
            {
                MessageBox.Show("Error: " + exc);
            }
        }
    }
}