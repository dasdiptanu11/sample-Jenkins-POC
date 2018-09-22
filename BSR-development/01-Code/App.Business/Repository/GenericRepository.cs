using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Data.Entity;
using System.Linq.Expressions;

namespace App.Business {
    //public class SortExpression<TEntity, TType>
    //{
    //    Expression<Func<TEntity, TType>> SortProperty;
    //}

    public class GenericRepository<TEntity> where TEntity : class {
        // Database context of Entity Framework
        internal DbContext _context;

        // Database entity 
        internal DbSet<TEntity> _databaseSet;

        /// <summary>
        /// Constructor method - Initializes Database context
        /// </summary>
        /// <param name="context"></param>
        public GenericRepository(DbContext context) {
            this._context = context;
            this._databaseSet = context.Set<TEntity>();
        }

        /// <summary>
        /// Get the data from any entity in the database
        /// </summary>
        /// <param name="filter">Filtering list of instances</param>
        /// <param name="orderBy">Sorting list of instances</param>
        /// <param name="includeProperties">Properties to include</param>
        /// <returns></returns>
        public virtual IEnumerable<TEntity> Get(Expression<Func<TEntity, bool>> filter = null, Func<IQueryable<TEntity>, IOrderedQueryable<TEntity>> orderBy = null, string includeProperties = "") {

            IQueryable<TEntity> query = _databaseSet;

            if (filter != null) {
                query = query.Where(filter);
            }

            foreach (var includeProperty in includeProperties.Split
                (new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries)) {
                query = query.Include(includeProperty);
            }

            if (query != null) {
                if (orderBy != null) {
                    return orderBy(query).ToList();
                } else {
                    return query.ToList();
                }
            }

            return new List<TEntity>();
        }

        /// <summary>
        /// Find from the database with Id
        /// </summary>
        /// <param name="id">Id parameter for the search</param>
        /// <returns>Returns data with matching parameter</returns>
        public virtual TEntity GetByID(object id) {
            return _databaseSet.Find(id);
        }

        /// <summary>
        /// Inserting a data in an entity
        /// </summary>
        /// <param name="entity">Entity instance to be inserted in the database</param>
        public virtual void Insert(TEntity entity) {
            _databaseSet.Add(entity);
        }

        /// <summary>
        /// Deleting an entity instance from the database
        /// </summary>
        /// <param name="id">Id parameter for deleting an instance</param>
        public virtual void Delete(object id) {
            TEntity entityToDelete = _databaseSet.Find(id);
            Delete(entityToDelete);
        }

        /// <summary>
        /// Deleting database Entity from database
        /// </summary>
        /// <param name="entityToDelete">entity to delete</param>
        public virtual void Delete(TEntity entityToDelete) {
            if (_context.Entry(entityToDelete).State == EntityState.Detached) {
                _databaseSet.Attach(entityToDelete);
            }

            _databaseSet.Remove(entityToDelete);
        }

        /// <summary>
        /// Updating an entity instance in the database
        /// </summary>
        /// <param name="entityToUpdate">Entity instance to be updated in the database</param>
        public virtual void Update(TEntity entityToUpdate) {
            _databaseSet.Attach(entityToUpdate);
            _context.Entry(entityToUpdate).State = EntityState.Modified;
        }

        /// <summary>
        /// Get data from the database using and SQL query
        /// </summary>
        /// <param name="query">SQL query to execute</param>
        /// <param name="parameters">parameter of the SQL query</param>
        /// <returns>Returns the Result of the SQL query</returns>
        public virtual IEnumerable<TEntity> GetWithRawSql(string query, params object[] parameters) {
            return _databaseSet.SqlQuery(query, parameters).ToList();
        }
    }
}