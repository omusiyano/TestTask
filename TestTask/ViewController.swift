import UIKit
import Charts
class ViewController: UIViewController {
    
    //Create Variables and const
    var valueCurrenciesPB: decodePrivat? = nil
    var valueCurrenciesNbu: [decodingNBU]? = nil
    let formatterPB = DateFormatter()
    let formatterNbu = DateFormatter()
    var yValues:[ChartDataEntry] = [
        ChartDataEntry(x: 1, y: 26.7),
        ChartDataEntry(x: 2, y: 27.4),
        ChartDataEntry(x: 3, y: 28.3),
        ChartDataEntry(x: 4, y: 26.4),
        ChartDataEntry(x: 5, y: 25.4),
        ChartDataEntry(x: 6, y: 30.4)
    ]
    
    //Outlets
    @IBOutlet weak var tableViewNBU: UITableView!
    @IBOutlet weak var datePB: UIDatePicker!
    @IBOutlet weak var dateNBU: UIDatePicker!
    @IBOutlet weak var tableViewPrivat: UITableView!
    @IBOutlet weak var stackViewDate: UIStackView!
    @IBOutlet weak var lineChart: LineChartView!
    
    //Realization change currencies for PrivatBank with date choosing
    @IBAction func changeDatePB(_ sender: UIDatePicker) {
        currencyPb()
    }
    
    //Realization change currencies for NBU with date choosing
    @IBAction func changeDateNBU(_ sender: UIDatePicker) {
        currencyNbu()
    }
    
    //Realization append Arrays for Charts. It needs some algorythm for iterate over dates, and transfer arguments instead of "0" in functions. it must work for any change - like min data or max data
    @IBAction func changeDateChartsFrom(_ sender: UIDatePicker) {
       appendItem(row: 0, rate: 0)
    }
    @IBAction func changeDateChartsTill(_ sender: Any) {
        appendItem(row: 0, rate: 0)
    }
    
    //Realization Chart
    @IBAction func buttonChartAction(_ sender: UIBarButtonItem) {
        if lineChart.isHidden == true{
            lineChart.isHidden = false
            stackViewDate.isHidden = false
        }else{
            lineChart.isHidden = true
            stackViewDate.isHidden = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormat()
        setupTableViewPb()
        setupTableViewNbu()
        currencyPb()
        currencyNbu()
        lineChartSetup()
    }
    
    //Setup Line Chart
    func lineChartSetup() {
        lineChart?.rightAxis.enabled = false
//        lineChart?.animate(xAxisDuration: 1) //-animation looks like freeze bag
        lineChart?.backgroundColor = .systemGreen
        setDataChart()
    }
    
    //Append for Dataset of lineChart
    func appendItem(row:Double, rate:Double) {
        yValues.append(ChartDataEntry(x: row, y: rate))
    }
    
    //Date Format and formatter for PB and NBU Datepickers
    private func dateFormat(){
        datePB.timeZone = .current
        dateNBU.timeZone = .current
        dateNBU.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        datePB.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        formatterPB.dateFormat = "dd.MM.yyyy"
        formatterNbu.dateFormat = "yyyyMMdd"
    }
    
    //TableView Setup for PB
    private func setupTableViewPb(){
        tableViewPrivat.delegate = self
        tableViewPrivat.dataSource = self
        tableViewPrivat.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    //TableView Setup for NBU
    private func setupTableViewNbu(){
        tableViewNBU.delegate = self
        tableViewNBU.dataSource = self
        tableViewNBU.register(UINib(nibName: "NbuTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    //Getting currencies NBU
    func currencyNbu(){
        let dateNbu = dateNBU.date
        let urlNBUJSON = "https://bank.gov.ua/NBUStatService/v1/statdirectory/exchange?date=\(formatterNbu.string(from: dateNbu))&json"
        requestCurrenciesNBU(urlStringNBU: urlNBUJSON) { [weak self](result) in
            switch result{
            case .success(let valueCurNbu):
                self?.valueCurrenciesNbu = valueCurNbu
                self?.tableViewNBU.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //Getting currencies PB
    func currencyPb(){
        let datePb = datePB.date
        let urlPrivatJSON = "https://api.privatbank.ua/p24api/exchange_rates?json&date=\(formatterPB.string(from: datePb))"
        requestCurrencies(urlString: urlPrivatJSON) { (result) in
            switch result{
            case .success(let valueCurrencies):
                self.valueCurrenciesPB = valueCurrencies
                self.tableViewPrivat.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //DataSet setup for charts
    func setDataChart(){
        let set1 = LineChartDataSet(entries: yValues, label: "UAH for USD")
        let data = LineChartData(dataSet: set1)
        set1.mode = .horizontalBezier
        set1.lineWidth = 3
        set1.setColor(.white)
        set1.fillAlpha = 0.8
        set1.drawFilledEnabled = true
        set1.fillColor = .white
        set1.drawCirclesEnabled = false
        data.setDrawValues(false)
        lineChart?.data = data
    }

}


extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Scrolling on tap
        if tableView == self.tableViewPrivat{
            let currentCell = tableView.cellForRow(at: indexPath)
            let textCellPB = currentCell?.description
            if (textCellPB!.contains("USD")){scrollToSelectedRow(row: 26)}
            else if (textCellPB!.contains("CHF")){scrollToSelectedRow(row: 23)}
            else if (textCellPB!.contains("EUR")){scrollToSelectedRow(row: 32)}
            else if (textCellPB!.contains("GBP")){scrollToSelectedRow(row: 25)}
            else if (textCellPB!.contains("PLZ")){scrollToSelectedRow(row: 33)}
            else if (textCellPB!.contains("RUB")){scrollToSelectedRow(row: 18)}
            else if (textCellPB!.contains("CAD")){scrollToSelectedRow(row: 1)}
            else if (textCellPB!.contains("CZK")){scrollToSelectedRow(row: 4)}
        }
    }
    
    //Func for scrolling on tap
    func scrollToSelectedRow(row:Int) {
        let indexPath = IndexPath(row: row, section: 0)
        self.tableViewNBU.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    //Cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableViewPrivat{
        return valueCurrenciesPB?.exchangeRate.count ?? 0
        }else {
            return valueCurrenciesNbu?.count ?? 0
        }
    }
    
    //Values in cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Check for table - PB or NBU
        if tableView == self.tableViewPrivat{
            let cell = tableViewPrivat.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let currencie = valueCurrenciesPB?.exchangeRate[indexPath.row]
            if currencie?.purchaseRate != nil{
            cell.textLabel?.text = "\(currencie?.currency ?? "UAH")\t\t\t\t\(currencie?.purchaseRate ?? 0)\t\t\t\t\(currencie?.saleRate ?? 0)"
                cell.textLabel?.textAlignment = .center
        }
            return cell
        }else{
            let cell = tableViewNBU.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NbuTableViewCell
            let currencie = valueCurrenciesNbu?[indexPath.row]
            cell.titleCurrencies.text = currencie?.txt ?? "Гривна"
            cell.titleCc.text = "1 \(currencie?.cc ?? "UAH")"
            cell.titleRate.text = "\(currencie?.rate ?? 0) UAH"
            cell.backgroundColor = .systemGreen
            return cell
        }
    }
}


