namespace _2017_12_23
{
    partial class Buyers_List
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.panel1 = new System.Windows.Forms.Panel();
            this.buttonGetTopBuyers = new System.Windows.Forms.Button();
            this.buttonAddOrder = new System.Windows.Forms.Button();
            this.buttonLoadBuyerOrders = new System.Windows.Forms.Button();
            this.buttonUpdateBuyer = new System.Windows.Forms.Button();
            this.buttonRemoveBuyer = new System.Windows.Forms.Button();
            this.buttonAddBuyer = new System.Windows.Forms.Button();
            this.buttonLoadBuyers = new System.Windows.Forms.Button();
            this.listBoxBuyerList = new System.Windows.Forms.ListBox();
            this.panel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.buttonGetTopBuyers);
            this.panel1.Controls.Add(this.buttonAddOrder);
            this.panel1.Controls.Add(this.buttonLoadBuyerOrders);
            this.panel1.Controls.Add(this.buttonUpdateBuyer);
            this.panel1.Controls.Add(this.buttonRemoveBuyer);
            this.panel1.Controls.Add(this.buttonAddBuyer);
            this.panel1.Controls.Add(this.buttonLoadBuyers);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Right;
            this.panel1.Location = new System.Drawing.Point(401, 0);
            this.panel1.MinimumSize = new System.Drawing.Size(120, 164);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(120, 262);
            this.panel1.TabIndex = 0;
            // 
            // buttonGetTopBuyers
            // 
            this.buttonGetTopBuyers.Location = new System.Drawing.Point(6, 187);
            this.buttonGetTopBuyers.Name = "buttonGetTopBuyers";
            this.buttonGetTopBuyers.Size = new System.Drawing.Size(107, 23);
            this.buttonGetTopBuyers.TabIndex = 6;
            this.buttonGetTopBuyers.Text = "Get top buyers";
            this.buttonGetTopBuyers.UseVisualStyleBackColor = true;
            this.buttonGetTopBuyers.Click += new System.EventHandler(this.buttonGetTopBuyers_Click);
            // 
            // buttonAddOrder
            // 
            this.buttonAddOrder.Location = new System.Drawing.Point(6, 158);
            this.buttonAddOrder.Name = "buttonAddOrder";
            this.buttonAddOrder.Size = new System.Drawing.Size(107, 23);
            this.buttonAddOrder.TabIndex = 5;
            this.buttonAddOrder.Text = "Add Order";
            this.buttonAddOrder.UseVisualStyleBackColor = true;
            this.buttonAddOrder.Click += new System.EventHandler(this.buttonAddOrder_Click);
            // 
            // buttonLoadBuyerOrders
            // 
            this.buttonLoadBuyerOrders.Location = new System.Drawing.Point(7, 70);
            this.buttonLoadBuyerOrders.Name = "buttonLoadBuyerOrders";
            this.buttonLoadBuyerOrders.Size = new System.Drawing.Size(107, 23);
            this.buttonLoadBuyerOrders.TabIndex = 4;
            this.buttonLoadBuyerOrders.Text = "Load Buyer Orders";
            this.buttonLoadBuyerOrders.UseVisualStyleBackColor = true;
            this.buttonLoadBuyerOrders.Click += new System.EventHandler(this.buttonLoadBuyerOrders_Click);
            // 
            // buttonUpdateBuyer
            // 
            this.buttonUpdateBuyer.Location = new System.Drawing.Point(7, 100);
            this.buttonUpdateBuyer.Name = "buttonUpdateBuyer";
            this.buttonUpdateBuyer.Size = new System.Drawing.Size(106, 23);
            this.buttonUpdateBuyer.TabIndex = 3;
            this.buttonUpdateBuyer.Text = "Update Buyer";
            this.buttonUpdateBuyer.UseVisualStyleBackColor = true;
            this.buttonUpdateBuyer.Click += new System.EventHandler(this.buttonUpdateBuyer_Click);
            // 
            // buttonRemoveBuyer
            // 
            this.buttonRemoveBuyer.Location = new System.Drawing.Point(7, 129);
            this.buttonRemoveBuyer.Name = "buttonRemoveBuyer";
            this.buttonRemoveBuyer.Size = new System.Drawing.Size(106, 23);
            this.buttonRemoveBuyer.TabIndex = 2;
            this.buttonRemoveBuyer.Text = "Remove Buyer";
            this.buttonRemoveBuyer.UseVisualStyleBackColor = true;
            this.buttonRemoveBuyer.Click += new System.EventHandler(this.buttonRemoveBuyer_Click);
            // 
            // buttonAddBuyer
            // 
            this.buttonAddBuyer.Location = new System.Drawing.Point(6, 41);
            this.buttonAddBuyer.Name = "buttonAddBuyer";
            this.buttonAddBuyer.Size = new System.Drawing.Size(107, 23);
            this.buttonAddBuyer.TabIndex = 1;
            this.buttonAddBuyer.Text = "Add Buyer";
            this.buttonAddBuyer.UseVisualStyleBackColor = true;
            this.buttonAddBuyer.Click += new System.EventHandler(this.buttonAddBuyer_Click);
            // 
            // buttonLoadBuyers
            // 
            this.buttonLoadBuyers.Location = new System.Drawing.Point(6, 12);
            this.buttonLoadBuyers.Name = "buttonLoadBuyers";
            this.buttonLoadBuyers.Size = new System.Drawing.Size(107, 23);
            this.buttonLoadBuyers.TabIndex = 0;
            this.buttonLoadBuyers.Text = "Load Buyers";
            this.buttonLoadBuyers.UseVisualStyleBackColor = true;
            this.buttonLoadBuyers.Click += new System.EventHandler(this.buttonLoadBuyers_Click);
            // 
            // listBoxBuyerList
            // 
            this.listBoxBuyerList.Dock = System.Windows.Forms.DockStyle.Fill;
            this.listBoxBuyerList.FormattingEnabled = true;
            this.listBoxBuyerList.Location = new System.Drawing.Point(0, 0);
            this.listBoxBuyerList.Name = "listBoxBuyerList";
            this.listBoxBuyerList.Size = new System.Drawing.Size(401, 262);
            this.listBoxBuyerList.TabIndex = 1;
            // 
            // Buyers_List
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(521, 262);
            this.Controls.Add(this.listBoxBuyerList);
            this.Controls.Add(this.panel1);
            this.MinimumSize = new System.Drawing.Size(435, 202);
            this.Name = "Buyers_List";
            this.Text = "Buyers_List";
            this.panel1.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Button buttonLoadBuyerOrders;
        private System.Windows.Forms.Button buttonUpdateBuyer;
        private System.Windows.Forms.Button buttonRemoveBuyer;
        private System.Windows.Forms.Button buttonAddBuyer;
        private System.Windows.Forms.Button buttonLoadBuyers;
        private System.Windows.Forms.ListBox listBoxBuyerList;
        private System.Windows.Forms.Button buttonAddOrder;
        private System.Windows.Forms.Button buttonGetTopBuyers;
    }
}