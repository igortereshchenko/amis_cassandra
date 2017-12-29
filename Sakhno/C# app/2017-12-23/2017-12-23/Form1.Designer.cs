namespace _2017_12_23
{
    partial class Form1
    {
        /// <summary>
        /// Требуется переменная конструктора.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Освободить все используемые ресурсы.
        /// </summary>
        /// <param name="disposing">истинно, если управляемый ресурс должен быть удален; иначе ложно.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Код, автоматически созданный конструктором форм Windows

        /// <summary>
        /// Обязательный метод для поддержки конструктора - не изменяйте
        /// содержимое данного метода при помощи редактора кода.
        /// </summary>
        private void InitializeComponent()
        {
            this.buttonConnect = new System.Windows.Forms.Button();
            this.textBoxAddress = new System.Windows.Forms.TextBox();
            this.panel1 = new System.Windows.Forms.Panel();
            this.panel2 = new System.Windows.Forms.Panel();
            this.panelControls = new System.Windows.Forms.Panel();
            this.panel5 = new System.Windows.Forms.Panel();
            this.listBoxOrders = new System.Windows.Forms.ListBox();
            this.label1 = new System.Windows.Forms.Label();
            this.panel4 = new System.Windows.Forms.Panel();
            this.buttonProductStat = new System.Windows.Forms.Button();
            this.buttonRemOrder = new System.Windows.Forms.Button();
            this.buttonAddSupply = new System.Windows.Forms.Button();
            this.buttonListBuyers = new System.Windows.Forms.Button();
            this.buttonListOrders = new System.Windows.Forms.Button();
            this.panel1.SuspendLayout();
            this.panel2.SuspendLayout();
            this.panelControls.SuspendLayout();
            this.panel5.SuspendLayout();
            this.panel4.SuspendLayout();
            this.SuspendLayout();
            // 
            // buttonConnect
            // 
            this.buttonConnect.Dock = System.Windows.Forms.DockStyle.Fill;
            this.buttonConnect.Location = new System.Drawing.Point(10, 0);
            this.buttonConnect.Margin = new System.Windows.Forms.Padding(10);
            this.buttonConnect.Name = "buttonConnect";
            this.buttonConnect.Size = new System.Drawing.Size(80, 24);
            this.buttonConnect.TabIndex = 0;
            this.buttonConnect.Text = "Connect";
            this.buttonConnect.UseVisualStyleBackColor = true;
            this.buttonConnect.Click += new System.EventHandler(this.buttonConnect_Click);
            // 
            // textBoxAddress
            // 
            this.textBoxAddress.Dock = System.Windows.Forms.DockStyle.Fill;
            this.textBoxAddress.Location = new System.Drawing.Point(0, 0);
            this.textBoxAddress.Name = "textBoxAddress";
            this.textBoxAddress.Size = new System.Drawing.Size(635, 20);
            this.textBoxAddress.TabIndex = 1;
            this.textBoxAddress.Text = "localhost";
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.textBoxAddress);
            this.panel1.Controls.Add(this.panel2);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel1.Location = new System.Drawing.Point(10, 10);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(725, 24);
            this.panel1.TabIndex = 2;
            // 
            // panel2
            // 
            this.panel2.Controls.Add(this.buttonConnect);
            this.panel2.Dock = System.Windows.Forms.DockStyle.Right;
            this.panel2.Location = new System.Drawing.Point(635, 0);
            this.panel2.Name = "panel2";
            this.panel2.Padding = new System.Windows.Forms.Padding(10, 0, 0, 0);
            this.panel2.Size = new System.Drawing.Size(90, 24);
            this.panel2.TabIndex = 2;
            // 
            // panelControls
            // 
            this.panelControls.Controls.Add(this.panel5);
            this.panelControls.Controls.Add(this.panel4);
            this.panelControls.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panelControls.Location = new System.Drawing.Point(10, 34);
            this.panelControls.Name = "panelControls";
            this.panelControls.Padding = new System.Windows.Forms.Padding(0, 10, 0, 0);
            this.panelControls.Size = new System.Drawing.Size(725, 333);
            this.panelControls.TabIndex = 3;
            this.panelControls.Visible = false;
            // 
            // panel5
            // 
            this.panel5.Controls.Add(this.listBoxOrders);
            this.panel5.Controls.Add(this.label1);
            this.panel5.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel5.Location = new System.Drawing.Point(0, 10);
            this.panel5.Name = "panel5";
            this.panel5.Size = new System.Drawing.Size(623, 323);
            this.panel5.TabIndex = 1;
            // 
            // listBoxOrders
            // 
            this.listBoxOrders.Dock = System.Windows.Forms.DockStyle.Fill;
            this.listBoxOrders.FormattingEnabled = true;
            this.listBoxOrders.Location = new System.Drawing.Point(0, 13);
            this.listBoxOrders.Name = "listBoxOrders";
            this.listBoxOrders.Size = new System.Drawing.Size(623, 310);
            this.listBoxOrders.TabIndex = 1;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Dock = System.Windows.Forms.DockStyle.Top;
            this.label1.Location = new System.Drawing.Point(0, 0);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(38, 13);
            this.label1.TabIndex = 0;
            this.label1.Text = "Orders";
            // 
            // panel4
            // 
            this.panel4.AutoScroll = true;
            this.panel4.Controls.Add(this.buttonProductStat);
            this.panel4.Controls.Add(this.buttonRemOrder);
            this.panel4.Controls.Add(this.buttonAddSupply);
            this.panel4.Controls.Add(this.buttonListBuyers);
            this.panel4.Controls.Add(this.buttonListOrders);
            this.panel4.Dock = System.Windows.Forms.DockStyle.Right;
            this.panel4.Location = new System.Drawing.Point(623, 10);
            this.panel4.Name = "panel4";
            this.panel4.Size = new System.Drawing.Size(102, 323);
            this.panel4.TabIndex = 0;
            // 
            // buttonProductStat
            // 
            this.buttonProductStat.Location = new System.Drawing.Point(6, 134);
            this.buttonProductStat.Name = "buttonProductStat";
            this.buttonProductStat.Size = new System.Drawing.Size(88, 23);
            this.buttonProductStat.TabIndex = 4;
            this.buttonProductStat.Text = "Product stat";
            this.buttonProductStat.UseVisualStyleBackColor = true;
            this.buttonProductStat.Click += new System.EventHandler(this.buttonProductStat_Click);
            // 
            // buttonRemOrder
            // 
            this.buttonRemOrder.Location = new System.Drawing.Point(6, 105);
            this.buttonRemOrder.Name = "buttonRemOrder";
            this.buttonRemOrder.Size = new System.Drawing.Size(88, 23);
            this.buttonRemOrder.TabIndex = 3;
            this.buttonRemOrder.Text = "Rem order";
            this.buttonRemOrder.UseVisualStyleBackColor = true;
            this.buttonRemOrder.Click += new System.EventHandler(this.buttonRemOrder_Click);
            // 
            // buttonAddSupply
            // 
            this.buttonAddSupply.Location = new System.Drawing.Point(6, 76);
            this.buttonAddSupply.Name = "buttonAddSupply";
            this.buttonAddSupply.Size = new System.Drawing.Size(88, 23);
            this.buttonAddSupply.TabIndex = 2;
            this.buttonAddSupply.Text = "Add supply";
            this.buttonAddSupply.UseVisualStyleBackColor = true;
            this.buttonAddSupply.Click += new System.EventHandler(this.buttonAddSupply_Click);
            // 
            // buttonListBuyers
            // 
            this.buttonListBuyers.Location = new System.Drawing.Point(6, 47);
            this.buttonListBuyers.Name = "buttonListBuyers";
            this.buttonListBuyers.Size = new System.Drawing.Size(88, 23);
            this.buttonListBuyers.TabIndex = 1;
            this.buttonListBuyers.Text = "List buyers";
            this.buttonListBuyers.UseVisualStyleBackColor = true;
            this.buttonListBuyers.Click += new System.EventHandler(this.buttonListBuyers_Click);
            // 
            // buttonListOrders
            // 
            this.buttonListOrders.Location = new System.Drawing.Point(6, 18);
            this.buttonListOrders.Name = "buttonListOrders";
            this.buttonListOrders.Size = new System.Drawing.Size(88, 23);
            this.buttonListOrders.TabIndex = 0;
            this.buttonListOrders.Text = "List orders";
            this.buttonListOrders.UseVisualStyleBackColor = true;
            this.buttonListOrders.Click += new System.EventHandler(this.buttonListOrders_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(745, 377);
            this.Controls.Add(this.panelControls);
            this.Controls.Add(this.panel1);
            this.MinimumSize = new System.Drawing.Size(300, 200);
            this.Name = "Form1";
            this.Padding = new System.Windows.Forms.Padding(10);
            this.Text = "Form1";
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.Form1_FormClosed);
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.panel2.ResumeLayout(false);
            this.panelControls.ResumeLayout(false);
            this.panel5.ResumeLayout(false);
            this.panel5.PerformLayout();
            this.panel4.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button buttonConnect;
        private System.Windows.Forms.TextBox textBoxAddress;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Panel panel2;
        private System.Windows.Forms.Panel panelControls;
        private System.Windows.Forms.Panel panel5;
        public System.Windows.Forms.ListBox listBoxOrders;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Panel panel4;
        private System.Windows.Forms.Button buttonListOrders;
        private System.Windows.Forms.Button buttonAddBuyer;
        private System.Windows.Forms.Button buttonListBuyers;
        private System.Windows.Forms.Button buttonAddSupply;
        private System.Windows.Forms.Button buttonRemOrder;
        private System.Windows.Forms.Button buttonProductStat;
    }
}

