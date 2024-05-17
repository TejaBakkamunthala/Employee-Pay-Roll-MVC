using BusinessLayer.Interfaces;
using BusinessLayer.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Routing;
using ModelLayer;
using NuGet.DependencyResolver;
using System.Reflection;

namespace EmployeePayRoll.Controllers
{
    public class EmployeeController : Controller
    {
        private readonly IEmployeeBL iemployeeBL;

        public EmployeeController(IEmployeeBL iemployeeBL)
        {
            this.iemployeeBL = iemployeeBL;
        }

        [HttpGet]
        [Route("GetAll")]
        public IActionResult Index()
        {
            List<EmployeeModel> lstEmployee = new List<EmployeeModel>();
            lstEmployee = iemployeeBL.GetEmployees().ToList();

            return View(lstEmployee);

        }


        [HttpGet]
        [Route("Create")]
        public IActionResult Create()
        {
            ViewBag.data = "Add Employee";

            return View();
        }


        [HttpPost]
        [Route("Create")]
        [ValidateAntiForgeryToken]
        public IActionResult Create([Bind] EmployeeModel empModel)
        {
            if (ModelState.IsValid)
            {
                iemployeeBL.RegisterEmployee(empModel);
                return RedirectToAction("Index");
            }
            return View(empModel);
        }






        [HttpGet]
        [Route("Update/{id}")]

        public IActionResult Edit(int Id)
        {
            if (Id == null)
            {
                return NotFound();
            }
            EmployeeModel empModel = iemployeeBL.GetEmployeById(Id);
            if (empModel == null)
            {
                return NotFound();
            }
            return View(empModel);
        }

        [HttpPost]
        [Route("Update/{id}")]
        public IActionResult Edit(int id, [Bind] EmployeeModel empModel)
        {
            if (id != empModel.EmpId)
            {
                return NotFound();
            }
            try
            {
                if (ModelState.IsValid)
                {
                    iemployeeBL.UpdateEmployee(empModel);
                    return RedirectToAction("Index");
                }
                return View();

            }
            catch (Exception ex)
            {
                ModelState.AddModelError(string.Empty, "error occured on processing request");
                return View(empModel);
            }
        }





        [HttpGet]
     //  [Route("GetById/{id}")]

        public IActionResult GetEmployeById(int Id)
        {
            Id = (int)HttpContext.Session.GetInt32("Id");

            if (Id == null)
            {
                return NotFound();

            }
            EmployeeModel empModel = iemployeeBL.GetEmployeById(Id);

            if (empModel == null)
            {
                return NotFound("Something Went Wrong");
            }
            return View(empModel);

        }



        [HttpGet]
        [Route("DeleteById/{Id}")]
        public IActionResult Delete(int Id)
        {
            if (Id == 0)
            {
                return NotFound("Employee Id is not present");
            }
            EmployeeModel empModel = iemployeeBL.GetEmployeById(Id);
            if (empModel == null)
            {
                return NotFound("Something Went wrong");
            }
            return View(empModel);
        }



        [HttpPost, ActionName("Delete")]
        [Route("DeleteById/{Id}")]
        [ValidateAntiForgeryToken]
        public IActionResult DeleteConfirmation(int Id)
        {
            var result = iemployeeBL.DeleteEmployee(Id);
            if (result)
            {
                return RedirectToAction("Index");
            }
            return NotFound();

        }

        //login

        [HttpGet]
        public IActionResult Login()
        {
            return View();

        }


        [HttpPost]
        public IActionResult Login(LoginModel inModel)
        {
            {
                var result = iemployeeBL.Login(inModel);

                if (result != null)
                {
                    HttpContext.Session.SetInt32("Id", result.EmpId);
                    return RedirectToAction("GetEmployeById");

                }
                else
                {
                    return null;
                }

            }
        }


        [HttpGet]
        [Route("GetByName")]
        public IActionResult GetByName()
        {
            return View("GetByName");
        }

        [HttpPost]
        [Route("GetByName")]
        public IActionResult GetByName(string EmpName)
        {
            EmployeeModel emp = new EmployeeModel();
            emp = iemployeeBL.GetSingleName(EmpName);
            List<EmployeeModel> employeeLst=new List<EmployeeModel>();
            employeeLst = iemployeeBL.GetEmployeByName(EmpName);
            emp=iemployeeBL.GetSingleName(EmpName);
            int count=iemployeeBL.GetEmployeByName(EmpName).Count();
            if (count == 1)
            {
                if (emp != null)
                {
                    return View("GetName", emp);
                }
            }
            else if (count > 1)
            {
                if (employeeLst != null)
                {
                    return View("Index", employeeLst);
                }
                else
                {
                    return null;
                }
            }
            return null;
        }


        







    }
}
