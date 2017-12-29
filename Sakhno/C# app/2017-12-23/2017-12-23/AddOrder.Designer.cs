namespace _2017_12_23
{
    partial class AddOrder
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
            this.buttonAddOrder = new System.Windows.Forms.Button();
            this.panel2 = new System.Windows.Forms.Panel();
            this.panel4 = new System.Windows.Forms.Panel();
            this.textBoxBuyerID = new System.Windows.Forms.TextBox();
            this.buttonOperationIDCalculate = new System.Windows.Forms.Button();
            this.buttonOperationDateFill = new System.Windows.Forms.Button();
            this.textBoxProductPrice = new System.Windows.Forms.TextBox();
            this.textBoxProductName = new System.Windows.Forms.TextBox();
            this.textBoxProductCount = new System.Windows.Forms.TextBox();
            this.textBoxProductProducer = new System.Windows.Forms.TextBox();
            this.textBoxWHName = new System.Windows.Forms.TextBox();
            this.textBoxOperationDate = new System.Windows.Forms.TextBox();
            this.textBoxOperationID = new System.Windows.Forms.TextBox();
            this.panel3 = new System.Windows.Forms.Panel();
            this.label1 = new System.Windows.Forms.Label();
            this.labelProductCount = new System.Windows.Forms.Label();
            this.labelProductPrice = new System.Windows.Forms.Label();
            this.labelProductProducer = new System.Windows.Forms.Label();
            this.labelProductName = new System.Windows.Forms.Label();
            this.labelWHName = new System.Windows.Forms.Label();
            this.labelBuyerID = new System.Windows.Forms.Label();
            this.labelOperationDate = new System.Windows.Forms.Label();
            this.labelOperationID = new System.Windows.Forms.Label();
            this.buttonMultiply = new System.Windows.Forms.Button();
            this.panel1.SuspendLayout();
            this.panel2.SuspendLayout();
            this.panel4.SuspendLayout();
            this.panel3.SuspendLayout();
            this.SuspendLayout();
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.buttonAddOrder);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.panel1.Location = new System.Drawing.Point(0, 230);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(335, 31);
            this.panel1.TabIndex = 0;
            // 
            // buttonAddOrder
            // 
            this.buttonAddOrder.Dock = System.Windows.Forms.DockStyle.Right;
            this.buttonAddOrder.Location = new System.Drawing.Point(260, 0);
            this.buttonAddOrder.Name = "buttonAddOrder";
            this.buttonAddOrder.Size = new System.Drawing.Size(75, 31);
            this.buttonAddOrder.TabIndex = 0;
            this.buttonAddOrder.Text = "Add Order";
            this.buttonAddOrder.UseVisualStyleBackColor = true;
            this.buttonAddOrder.Click += new System.EventHandler(this.buttonAddOrder_Click);
            // 
            // panel2
            // 
            this.panel2.Controls.Add(this.panel4);
            this.panel2.Controls.Add(this.panel3);
            this.panel2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel2.Location = new System.Drawing.Point(0, 0);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(335, 230);
            this.panel2.TabIndex = 1;
            // 
            // panel4
            // 
            this.panel4.Controls.Add(this.buttonMultiply);
            this.panel4.Controls.Add(this.textBoxBuyerID);
            this.panel4.Controls.Add(this.buttonOperationIDCalculate);
            this.panel4.Controls.Add(this.buttonOperationDateFill);
            this.panel4.Controls.Add(this.textBoxProductPrice);
            this.panel4.Controls.Add(this.textBoxProductName);
            this.panel4.Controls.Add(this.textBoxProductCount);
            this.panel4.Controls.Add(this.textBoxProductProducer);
            this.panel4.Controls.Add(this.textBoxWHName);
            this.panel4.Controls.Add(this.textBoxOperationDate);
            this.panel4.Controls.Add(this.textBoxOperationID);
            this.panel4.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel4.Location = new System.Drawing.Point(105, 0);
            this.panel4.Name = "panel4";
            this.panel4.Size = new System.Drawing.Size(230, 230);
            this.panel4.TabIndex = 1;
            // 
            // textBoxBuyerID
            // 
            this.textBoxBuyerID.Enabled = false;
            this.textBoxBuyerID.Location = new System.Drawing.Point(8, 84);
            this.textBoxBuyerID.Name = "textBoxBuyerID";
            this.textBoxBuyerID.Size = new System.Drawing.Size(213, 20);
            this.textBoxBuyerID.TabIndex = 11;
            // 
            // buttonOperationIDCalculate
            // 
            this.buttonOperationIDCalculate.Location = new System.Drawing.Point(161, 4);
            this.buttonOperationIDCalculate.Name = "buttonOperationIDCalculate";
            this.buttonOperationIDCalculate.Size = new System.Drawing.Size(60, 23);
            this.buttonOperationIDCalculate.TabIndex = 10;
            this.buttonOperationIDCalculate.Text = "Calculate";
            this.buttonOperationIDCalculate.UseVisualStyleBackColor = true;
            this.buttonOperationIDCalculate.Click += new System.EventHandler(this.buttonOperationIDCalculate_Click);
            // 
            // buttonOperationDateFill
            // 
            this.buttonOperationDateFill.Location = new System.Drawing.Point(161, 30);
            this.buttonOperationDateFill.Name = "buttonOperationDateFill";
            this.buttonOperationDateFill.Size = new System.Drawing.Size(60, 23);
            this.buttonOperationDateFill.TabIndex = 9;
            this.buttonOperationDateFill.Text = "Fill";
            this.buttonOperationDateFill.UseVisualStyleBackColor = true;
            this.buttonOperationDateFill.Click += new System.EventHandler(this.buttonOperationDateFill_Click);
            // 
            // textBoxProductPrice
            // 
            this.textBoxProductPrice.Location = new System.Drawing.Point(8, 163);
            this.textBoxProductPrice.Name = "textBoxProductPrice";
            this.textBoxProductPrice.Size = new System.Drawing.Size(146, 20);
            this.textBoxProductPrice.TabIndex = 7;
            this.textBoxProductPrice.Text = "0";
            // 
            // textBoxProductName
            // 
            this.textBoxProductName.Location = new System.Drawing.Point(8, 111);
            this.textBoxProductName.Name = "textBoxProductName";
            this.textBoxProductName.Size = new System.Drawing.Size(213, 20);
            this.textBoxProductName.TabIndex = 6;
            // 
            // textBoxProductCount
            // 
            this.textBoxProductCount.Location = new System.Drawing.Point(8, 189);
            this.textBoxProductCount.Name = "textBoxProductCount";
            this.textBoxProductCount.Size = new System.Drawing.Size(213, 20);
            this.textBoxProductCount.TabIndex = 5;
            this.textBoxProductCount.Text = "1";
            // 
            // textBoxProductProducer
            // 
            this.textBoxProductProducer.Location = new System.Drawing.Point(8, 137);
            this.textBoxProductProducer.Name = "textBoxProductProducer";
            this.textBoxProductProducer.Size = new System.Drawing.Size(213, 20);
            this.textBoxProductProducer.TabIndex = 4;
            // 
            // textBoxWHName
            // 
            this.textBoxWHName.Location = new System.Drawing.Point(8, 58);
            this.textBoxWHName.Name = "textBoxWHName";
            this.textBoxWHName.Size = new System.Drawing.Size(213, 20);
            this.textBoxWHName.TabIndex = 3;
            // 
            // textBoxOperationDate
            // 
            this.textBoxOperationDate.Location = new System.Drawing.Point(8, 32);
            this.textBoxOperationDate.Name = "textBoxOperationDate";
            this.textBoxOperationDate.Size = new System.Drawing.Size(146, 20);
            this.textBoxOperationDate.TabIndex = 2;
            // 
            // textBoxOperationID
            // 
            this.textBoxOperationID.Location = new System.Drawing.Point(8, 6);
            this.textBoxOperationID.Name = "textBoxOperationID";
            this.textBoxOperationID.Size = new System.Drawing.Size(146, 20);
            this.textBoxOperationID.TabIndex = 1;
            // 
            // panel3
            // 
            this.panel3.Controls.Add(this.label1);
            this.panel3.Controls.Add(this.labelProductCount);
            this.panel3.Controls.Add(this.labelProductPrice);
            this.panel3.Controls.Add(this.labelProductProducer);
            this.panel3.Controls.Add(this.labelProductName);
            this.panel3.Controls.Add(this.labelWHName);
            this.panel3.Controls.Add(this.labelBuyerID);
            this.panel3.Controls.Add(this.labelOperationDate);
            this.panel3.Controls.Add(this.labelOperationID);
            this.panel3.Dock = System.Windows.Forms.DockStyle.Left;
            this.panel3.Location = new System.Drawing.Point(0, 0);
            this.panel3.MaximumSize = new System.Drawing.Size(105, 232);
            this.panel3.MinimumSize = new System.Drawing.Size(105, 232);
            this.panel3.Name = "panel3";
            this.panel3.Size = new System.Drawing.Size(105, 232);
            this.panel3.TabIndex = 0;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 6.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label1.ForeColor = System.Drawing.SystemColors.ControlDarkDark;
            this.label1.Location = new System.Drawing.Point(9, 177);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(53, 12);
            this.label1.TabIndex = 8;
            this.label1.Text = "0 is wishlist";
            // 
            // labelProductCount
            // 
            this.labelProductCount.AutoSize = true;
            this.labelProductCount.Location = new System.Drawing.Point(8, 192);
            this.labelProductCount.Name = "labelProductCount";
            this.labelProductCount.Size = new System.Drawing.Size(78, 13);
            this.labelProductCount.TabIndex = 7;
            this.labelProductCount.Text = "Product Count:";
            // 
            // labelProductPrice
            // 
            this.labelProductPrice.AutoSize = true;
            this.labelProductPrice.Location = new System.Drawing.Point(8, 166);
            this.labelProductPrice.Name = "labelProductPrice";
            this.labelProductPrice.Size = new System.Drawing.Size(74, 13);
            this.labelProductPrice.TabIndex = 6;
            this.labelProductPrice.Text = "Product Price:";
            // 
            // labelProductProducer
            // 
            this.labelProductProducer.AutoSize = true;
            this.labelProductProducer.Location = new System.Drawing.Point(8, 140);
            this.labelProductProducer.Name = "labelProductProducer";
            this.labelProductProducer.Size = new System.Drawing.Size(93, 13);
            this.labelProductProducer.TabIndex = 5;
            this.labelProductProducer.Text = "Product Producer:";
            // 
            // labelProductName
            // 
            this.labelProductName.AutoSize = true;
            this.labelProductName.Location = new System.Drawing.Point(8, 114);
            this.labelProductName.Name = "labelProductName";
            this.labelProductName.Size = new System.Drawing.Size(78, 13);
            this.labelProductName.TabIndex = 4;
            this.labelProductName.Text = "Product Name:";
            // 
            // labelWHName
            // 
            this.labelWHName.AutoSize = true;
            this.labelWHName.Location = new System.Drawing.Point(8, 61);
            this.labelWHName.Name = "labelWHName";
            this.labelWHName.Size = new System.Drawing.Size(96, 13);
            this.labelWHName.TabIndex = 3;
            this.labelWHName.Text = "Warehouse Name:";
            // 
            // labelBuyerID
            // 
            this.labelBuyerID.AutoSize = true;
            this.labelBuyerID.Location = new System.Drawing.Point(8, 87);
            this.labelBuyerID.Name = "labelBuyerID";
            this.labelBuyerID.Size = new System.Drawing.Size(51, 13);
            this.labelBuyerID.TabIndex = 2;
            this.labelBuyerID.Text = "Buyer ID:";
            // 
            // labelOperationDate
            // 
            this.labelOperationDate.AutoSize = true;
            this.labelOperationDate.Location = new System.Drawing.Point(8, 35);
            this.labelOperationDate.Name = "labelOperationDate";
            this.labelOperationDate.Size = new System.Drawing.Size(82, 13);
            this.labelOperationDate.TabIndex = 1;
            this.labelOperationDate.Text = "Operation Date:";
            // 
            // labelOperationID
            // 
            this.labelOperationID.AutoSize = true;
            this.labelOperationID.Location = new System.Drawing.Point(8, 9);
            this.labelOperationID.Name = "labelOperationID";
            this.labelOperationID.Size = new System.Drawing.Size(70, 13);
            this.labelOperationID.TabIndex = 0;
            this.labelOperationID.Text = "Operation ID:";
            // 
            // buttonMultiply
            // 
            this.buttonMultiply.Location = new System.Drawing.Point(161, 161);
            this.buttonMultiply.Name = "buttonMultiply";
            this.buttonMultiply.Size = new System.Drawing.Size(60, 23);
            this.buttonMultiply.TabIndex = 12;
            this.buttonMultiply.Text = "Multiply";
            this.buttonMultiply.UseVisualStyleBackColor = true;
            this.buttonMultiply.Click += new System.EventHandler(this.buttonMultiply_Click);
            // 
            // AddOrder
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(335, 261);
            this.Controls.Add(this.panel2);
            this.Controls.Add(this.panel1);
            this.Name = "AddOrder";
            this.Text = "AddOrder";
            this.panel1.ResumeLayout(false);
            this.panel2.ResumeLayout(false);
            this.panel4.ResumeLayout(false);
            this.panel4.PerformLayout();
            this.panel3.ResumeLayout(false);
            this.panel3.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Button buttonAddOrder;
        private System.Windows.Forms.Panel panel2;
        private System.Windows.Forms.Panel panel4;
        private System.Windows.Forms.Panel panel3;
        private System.Windows.Forms.TextBox textBoxProductPrice;
        private System.Windows.Forms.TextBox textBoxProductName;
        private System.Windows.Forms.TextBox textBoxProductCount;
        private System.Windows.Forms.TextBox textBoxProductProducer;
        private System.Windows.Forms.TextBox textBoxWHName;
        private System.Windows.Forms.TextBox textBoxOperationDate;
        private System.Windows.Forms.TextBox textBoxOperationID;
        private System.Windows.Forms.Label labelProductCount;
        private System.Windows.Forms.Label labelProductPrice;
        private System.Windows.Forms.Label labelProductProducer;
        private System.Windows.Forms.Label labelProductName;
        private System.Windows.Forms.Label labelWHName;
        private System.Windows.Forms.Label labelBuyerID;
        private System.Windows.Forms.Label labelOperationDate;
        private System.Windows.Forms.Label labelOperationID;
        private System.Windows.Forms.Button buttonOperationIDCalculate;
        private System.Windows.Forms.Button buttonOperationDateFill;
        private System.Windows.Forms.TextBox textBoxBuyerID;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button buttonMultiply;
    }
}